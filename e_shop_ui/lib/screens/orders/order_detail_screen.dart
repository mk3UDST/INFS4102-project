// lib/screens/orders/order_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:e_shop_ui/models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  
  const OrderDetailScreen({
    Key? key,
    required this.order, required int orderId,
  }) : super(key: key);

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
        title: Text('Order #${order.id}'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            SizedBox(height: 20),
            _buildSectionHeader('Order Details'),
            _buildOrderInfo(),
            SizedBox(height: 20),
            _buildSectionHeader('Items'),
            _buildItemsList(),
            SizedBox(height: 20),
            _buildSectionHeader('Order Summary'),
            _buildOrderSummary(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getStatusIcon(order.status),
                color: _getStatusColor(order.status),
                size: 30,
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  order.status.toString().split('.').last,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: _getStatusColor(order.status),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.PENDING: return Icons.pending_actions;
      case OrderStatus.PROCESSING: return Icons.engineering;
      case OrderStatus.SHIPPED: return Icons.local_shipping;
      case OrderStatus.DELIVERED: return Icons.check_circle;
      case OrderStatus.CANCELED: return Icons.cancel;
      }
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildOrderInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Order ID', '#${order.id}'),
            SizedBox(height: 8),
            _buildInfoRow('Date', '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}'),
            SizedBox(height: 8),
            _buildInfoRow('Time', '${order.orderDate.hour}:${order.orderDate.minute.toString().padLeft(2, '0')}'),
            SizedBox(height: 8),
            _buildInfoRow('Items', '${order.items.length} items'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildItemsList() {
    return Card(
      elevation: 2,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: order.items.length,
        itemBuilder: (context, index) {
          final item = order.items[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.product.imageUrl != null
                ? Image.network(item.product.imageUrl!)
                : Icon(Icons.image, color: Colors.grey),
            ),
            title: Text(
              item.product.name,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${item.quantity} × \$${item.price.toStringAsFixed(2)}'),
            trailing: Text(
              '\$${item.total.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildOrderSummary(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Subtotal', '\$${order.totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            _buildInfoRow('Tax', '\$0.00'),
            SizedBox(height: 8),
            _buildInfoRow('Shipping', '\$0.00'),
            Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}