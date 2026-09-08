import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:order_placement_app/presentation/bloc/bloc/cart_bloc.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();

    context.read<CartBloc>().add(FetchCartItems());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart',style: TextStyle(
          fontWeight: FontWeight.w700,

        ),),
      ),

      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CartSuccess) {
            final cartItems = state.cartItems;

            if (cartItems.isEmpty) {
              return const Center(
                child: Text('Your cart is empty'),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cartItems[index];

                return CartItemWidget( placeholderColor: colorScheme.primary,
                imageUrl: item.imageUrl,
                  name: item.productName,
                  unitPrice: item.price,
                  quantity: item.quantity,
                  onQuantityChanged: (quantity) {
                    context.read<CartBloc>().add(
                      UpdateCartQuantity(
                        productId: item.productId,
                        quantity: quantity,
                      ),
                    );
                  },
                );
              },
            );
          }

          if (state is CartError) {
            return Center(
              child: Text(state.errorMessage),
            );
          }

          return const SizedBox();
        },
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),

          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is! CartSuccess) {
                return const SizedBox();
              }

              final cartItems = state.cartItems;

              final totalUnits = cartItems.fold<int>(
                0,
                (sum, item) => sum + item.quantity,
              );

              final grandTotal = cartItems.fold<double>(
                0,
                (sum, item) => sum + (item.price * item.quantity),
              );

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Items',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        '${cartItems.length}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Units',
                        style: theme.textTheme.bodyMedium,
                      ),
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
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
