import 'package:flutter/material.dart';
import 'package:e_shop_ui/models/cart_item.dart';
import 'package:e_shop_ui/models/product.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final Product product; // Pass the product details separately
  final Function(int) onQuantityChanged;
  final Function() onRemove;
  final bool isEditable;

  const CartItemCard({
    super.key,
    required this.item,
    required this.product,
    required this.onQuantityChanged,
    required this.onRemove,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('cart-item-${item.id}'),
      direction:
          isEditable ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Remove Item'),
              content: const Text(
                'Are you sure you want to remove this item from the cart?',
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (_) => onRemove(),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    product.imageUrl?.isNotEmpty == true
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image_outlined,
                                size: 40,
                                color: Colors.grey,
                              );
                            },
                          ),
                        )
                        : const Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
              ),
              const SizedBox(width: 16),

              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Price
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Quantity selector
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
                          const SizedBox(width: 8),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildQuantityButton(
                            icon: Icons.add,
                            onPressed:
                                () => onQuantityChanged(item.quantity + 1),
                          ),
                          const Spacer(),
                          // Subtotal
                          Text(
                            'Total: \$${(product.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
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
                            'Subtotal: \$${(product.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
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

  Widget _buildQuantityButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onPressed == null ? Colors.grey[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 18,
            color: onPressed == null ? Colors.grey[500] : Colors.black,
          ),
        ),
      ),
    );
  }
}
