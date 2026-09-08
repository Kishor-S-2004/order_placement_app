import 'package:flutter/material.dart';

import 'quantity_controller.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.placeholderColor,
    this.onQuantityChanged,
  });

  final String imageUrl;
  final String name;
  final double unitPrice;
  final int quantity;
  final Color placeholderColor;
  final ValueChanged<int>? onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final subtotal = unitPrice * quantity;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 72,
              height: 72,
              color: placeholderColor.withValues(alpha: 0.18),
              child: Image.network(imageUrl),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${unitPrice.toStringAsFixed(2)} each',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    QuantityController(
                      initialValue: quantity,
                      onChanged: onQuantityChanged,
                    ),
                    const SizedBox(width: 12),
                    // Expanded(
                    //   child: Text(
                    //     'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                    //     textAlign: TextAlign.end,
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: theme.textTheme.titleSmall?.copyWith(
                    //       color: colorScheme.primary,
                    //       fontWeight: FontWeight.w700,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
