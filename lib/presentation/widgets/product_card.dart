import 'package:flutter/material.dart';

import 'quantity_controller.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    this.placeholderColor = const Color(0xFFE2E8F0),
    this.onAddToCart,
    this.onQuantityChanged,
  });

  final String name;
  final double price;
  final String imageUrl;
  final int quantity;
  final Color placeholderColor;
  final VoidCallback? onAddToCart;
  final ValueChanged<int>? onQuantityChanged;

  Widget _imageFallback({double iconSize = 36}) {
    return Container(
      color: placeholderColor.withValues(alpha: 0.16),
      alignment: Alignment.center,
      child: Icon(
        Icons.shopping_bag_outlined,
        size: iconSize,
        color: placeholderColor,
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl.isEmpty) {
      return _imageFallback();
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _imageFallback(iconSize: 28);
      },
      errorBuilder: (context, error, stackTrace) => _imageFallback(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildImage(),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
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
                const SizedBox(height: 4),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                if (quantity > 0)
                  Center(
                    child: QuantityController(
                      initialValue: quantity,
                      onChanged: onQuantityChanged,
                    ),
                  )
                else
                  FilledButton.icon(
                    onPressed: onAddToCart,
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      size: 20,
                    ),
                    label: const Text('Add to Cart'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
