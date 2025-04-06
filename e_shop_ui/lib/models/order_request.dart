/// Model class for order creation requests
class OrderRequest {
  final String deliveryAddress;
  final String paymentMethod;

  OrderRequest({required this.deliveryAddress, required this.paymentMethod});

  Map<String, dynamic> toJson() {
    return {'deliveryAddress': deliveryAddress, 'paymentMethod': paymentMethod};
  }
}
