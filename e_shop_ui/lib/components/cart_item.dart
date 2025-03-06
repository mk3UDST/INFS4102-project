import 'package:flutter/material.dart';
import 'package:e_shop_ui/models/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final Function() onRemove;
  final bool isEditable;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    this.isEditable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('cart-item-${item.id}'),
      direction:
          isEditable ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Remove Item'),
              content: Text(
                'Are you sure you want to remove this item from the cart?',
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text('Remove', style: TextStyle(color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (_) => onRemove(),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image - FIXED: proper null check with ?. operator
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    item.product.imageUrl?.isNotEmpty == true
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.broken_image_outlined,
                                size: 40,
                                color: Colors.grey,
                              );
                            },
                          ),
                        )
                        : Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
              ),
              SizedBox(width: 16),

              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      item.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),

                    // Price
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Quantity selector - FIXED: larger touch targets
                    if (isEditable)
                      Row(
                        children: [
                          _buildQuantityButton(
                            icon: Icons.remove,
                            onPressed:
                                item.quantity > 1
                                    ? () => onQuantityChanged(item.quantity - 1)
                                    : null,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${item.quantity}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          _buildQuantityButton(
                            icon: Icons.add,
                            onPressed:
                                () => onQuantityChanged(item.quantity + 1),
                          ),
                          Spacer(),
                          // Subtotal
                          Text(
                            'Total: \$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    if (!isEditable)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantity: ${item.quantity}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            'Subtotal: \$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // FIXED: Better quantity button implementation with proper size
  Widget _buildQuantityButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32, // Increased size for better tap target
        height: 32, // Increased size for better tap target
        decoration: BoxDecoration(
          color: onPressed == null ? Colors.grey[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 18, // Slightly larger icon
            color: onPressed == null ? Colors.grey[500] : Colors.black,
          ),
        ),
      ),
    );
  }
}
