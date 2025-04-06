// lib/screens/orders/order_history_screen.dart
import 'package:flutter/material.dart';
import 'package:e_shop_ui/api/order_api.dart';
import 'package:e_shop_ui/models/order.dart';
import 'package:e_shop_ui/screens/orders/order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<Order>> _ordersFuture;
  
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }
  
  void _loadOrders() {
    // Hardcoded userId=1 for now
    _ordersFuture = OrderApi.getOrdersByUserId(1);
  }
  
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.PENDING: return Colors.orange;
      case OrderStatus.PROCESSING: return Colors.blue;
      case OrderStatus.SHIPPED: return Colors.indigo;
      case OrderStatus.DELIVERED: return Colors.green;
      case OrderStatus.CANCELED: return Colors.red;
      }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final order = snapshot.data![index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailScreen(order: order, orderId: order.id,),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order.id}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Chip(
                              label: Text(
                                order.status.toString().split('.').last,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: _getStatusColor(order.status),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.access_time, size: 16, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              '${order.orderDate.hour}:${order.orderDate.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${order.items.length} items',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '\$${order.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}