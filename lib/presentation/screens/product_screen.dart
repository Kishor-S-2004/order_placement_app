import 'package:flutter/material.dart';

import '../widgets/cart_badge.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

const _demoProducts = <({String name, double price, Color color})>[
  (name: 'Product Name', price: 29.99, color: Color(0xFF14B8A6)),
  (name: 'Product Two', price: 49.99, color: Color(0xFFF97316)),
  (name: 'Product Three', price: 19.99, color: Color(0xFF6366F1)),
  (name: 'Product Four', price: 79.99, color: Color(0xFFEC4899)),
];

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  void _openCart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: CartBadge(count: 2, onPressed: () => _openCart(context)),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.64,
        ),
        itemCount: _demoProducts.length,
        itemBuilder: (context, index) {
          final product = _demoProducts[index];
          return ProductCard(
            name: product.name,
            price: product.price,
            placeholderColor: product.color,
          );
        },
      ),
    );
  }
}