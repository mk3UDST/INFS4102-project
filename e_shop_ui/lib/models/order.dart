// lib/models/order.dart
import 'package:e_shop_ui/models/product.dart';

enum OrderStatus {
  PENDING,
  PROCESSING,
  SHIPPED,
  DELIVERED,
  CANCELED
}

class OrderItem {
  final Product product;
  final int quantity;
  final double price;
  
  OrderItem({
    required this.product,
    required this.quantity,
    required this.price,
  });
  
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }
  
  double get total => price * quantity;
}

class Order {
  final int id;
  final DateTime orderDate;
  final OrderStatus status;
  final double totalAmount;
  final List<OrderItem> items;
  
  Order({
    required this.id,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    required this.items,
  });
  
  factory Order.fromJson(Map<String, dynamic> json) {
    OrderStatus status = OrderStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status'],
      orElse: () => OrderStatus.PENDING,
    );
    
    return Order(
      id: json['id'],
      orderDate: DateTime.parse(json['orderDate']),
      status: status,
      totalAmount: json['totalAmount'].toDouble(),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}