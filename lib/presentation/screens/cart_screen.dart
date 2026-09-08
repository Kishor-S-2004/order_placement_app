import 'package:flutter/material.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const _cartProducts = <({String name, double unitPrice, Color color})>[
    (name: 'Product Name', unitPrice: 29.99, color: Color(0xFF14B8A6)),
    (name: 'Product Two', unitPrice: 29.99, color: Color(0xFFF97316)),
  ];

  final List<int> _quantities = [3, 2];

  void _updateQuantity(int index, int quantity) {
    setState(() => _quantities[index] = quantity);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalUnits = _quantities.fold<int>(0, (sum, qty) => sum + qty);
    var grandTotal = 0.0;
    for (var i = 0; i < _cartProducts.length; i++) {
      grandTotal += _cartProducts[i].unitPrice * _quantities[i];
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _cartProducts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = _cartProducts[index];
          return CartItemWidget(
            name: product.name,
            unitPrice: product.unitPrice,
            quantity: _quantities[index],
            placeholderColor: product.color,
            onQuantityChanged: (quantity) => _updateQuantity(index, quantity),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(color: colorScheme.outlineVariant),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Items', style: theme.textTheme.bodyMedium),
                  Text(
                    '${_cartProducts.length}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Units', style: theme.textTheme.bodyMedium),
                  Text(
                    '$totalUnits',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '\$${grandTotal.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}