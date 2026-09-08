import 'package:flutter/material.dart';

import 'quantity_controller.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.placeholderColor,
    this.onAddToCart,
    this.onQuantityChanged,
  });

  final String name;
  final double price;
  final Color placeholderColor;
  final VoidCallback? onAddToCart;
  final ValueChanged<int>? onQuantityChanged;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _addedToCart = false;
  int _quantity = 1;

  void _addToCart() {
    setState(() => _addedToCart = true);
    widget.onAddToCart?.call();
  }

  void _handleQuantityChanged(int value) {
    setState(() => _quantity = value);
    widget.onQuantityChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ColoredBox(
              color: widget.placeholderColor.withValues(alpha: 0.16),
              child: Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 36,
                  color: widget.placeholderColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${widget.price.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                if (_addedToCart)
                  Center(
                    child: QuantityController(
                      initialValue: _quantity,
                      onChanged: _handleQuantityChanged,
                    ),
                  )
                else
                  FilledButton.icon(
                    onPressed: _addToCart,
                    icon: const Icon(Icons.add_shopping_cart, size: 20),
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