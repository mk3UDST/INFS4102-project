import 'package:flutter/material.dart';
import 'package:e_shop_ui/models/order.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  
  const OrderStatusBadge({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          color: _getStatusColor(status),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
  
  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.PENDING:
        return 'Pending';
      case OrderStatus.PROCESSING:
        return 'Processing';
      case OrderStatus.SHIPPED:
        return 'Shipped';
      case OrderStatus.DELIVERED:
        return 'Delivered';
      case OrderStatus.CANCELED:
        return 'Canceled';
      }
  }
  
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.PENDING:
        return Colors.orange;
      case OrderStatus.PROCESSING:
        return Colors.blue;
      case OrderStatus.SHIPPED:
        return Colors.indigo;
      case OrderStatus.DELIVERED:
        return Colors.green;
      case OrderStatus.CANCELED:
        return Colors.red;
      }
  }
}