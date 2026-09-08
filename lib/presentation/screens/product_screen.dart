import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_placement_app/data/model/product_model.dart';
import 'package:order_placement_app/presentation/bloc/bloc/products_bloc.dart';

import '../widgets/cart_badge.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

const _placeholderPalette = <Color>[
  Color(0xFF14B8A6),
  Color(0xFFF97316),
  Color(0xFF6366F1),
  Color(0xFFEC4899),
  Color(0xFF22C55E),
  Color(0xFFF59E0B),
];

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  void _openCart() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CartScreen()));
  }

  void _fetchProducts() {
    context.read<ProductsBloc>().add(FetchProductDetails());
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: CartBadge(count: 2, onPressed: _openCart),
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          return switch (state) {
            ProductsInitial() || ProductsLoading() =>
              const Center(child: CircularProgressIndicator()),
            ProductsError(:final errorMessage) =>
              _buildErrorView(errorMessage),
            ProductSuccess(:final productDetails) =>
              _buildProductGrid(productDetails),
          };
        },
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No products available'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.64,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          name: product.productName,
          price: product.price,
          imageUrl: product.imageUrl,
          placeholderColor:
              _placeholderPalette[product.productId % _placeholderPalette.length],
        );
      },
    );
  }

  Widget _buildErrorView(String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: colorScheme.error),
            const SizedBox(height: 12),
            Text('Failed to load products', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _fetchProducts,
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}