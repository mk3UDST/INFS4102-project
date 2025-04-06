import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final Function(int) onChanged;
  final bool compact;
  
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.remove,
            onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
            compact: compact,
          ),
          Container(
            width: compact ? 30 : 40,
            alignment: Alignment.center,
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: compact ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildButton(
            icon: Icons.add,
            onTap: quantity < maxQuantity ? () => onChanged(quantity + 1) : null,
            compact: compact,
          ),
        ],
      ),
    );
  }
  
  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool compact,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: compact ? 30 : 36,
        height: compact ? 30 : 36,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: compact ? 16 : 20,
          color: onTap == null ? Colors.grey : null,
        ),
      ),
    );
  }
}