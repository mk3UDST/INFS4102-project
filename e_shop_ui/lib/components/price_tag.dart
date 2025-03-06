import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final bool showDiscount;
  final bool large;
  
  const PriceTag({
    Key? key,
    required this.price,
    this.originalPrice,
    this.showDiscount = false,
    this.large = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;
    
    if (!hasDiscount || !showDiscount) {
      return Text(
        '\$${price.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: large ? 24 : 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    
    // Calculate discount percentage
    final discountPercentage = ((originalPrice! - price) / originalPrice! * 100).round();
    
    return Row(
      children: [
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: large ? 24 : 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(width: 8),
        Text(
          '\$${originalPrice!.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: large ? 16 : 12,
            decoration: TextDecoration.lineThrough,
            color: Colors.grey,
          ),
        ),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '-$discountPercentage%',
            style: TextStyle(
              fontSize: large ? 12 : 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}