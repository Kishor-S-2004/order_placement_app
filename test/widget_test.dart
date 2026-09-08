import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:order_placement_app/data/model/product_model.dart';
import 'package:order_placement_app/data/repositories/product_repository.dart';
import 'package:order_placement_app/presentation/bloc/bloc/products_bloc.dart';
import 'package:order_placement_app/presentation/screens/product_screen.dart';

class _FakeProductRepository extends ProductRepository {
  @override
  Future<List<ProductModel>> fetchProducts() async {
    return [
      ProductModel(
        productId: 1,
        productName: 'Fake Product',
        price: 9.99,
        imageUrl: 'https://example.com/fake.png',
      ),
    ];
  }
}

void main() {
  testWidgets('renders product listing from bloc', (tester) async {
    final bloc = ProductsBloc(_FakeProductRepository());

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [BlocProvider<ProductsBloc>.value(value: bloc)],
        child: const MaterialApp(home: ProductScreen()),
      ),
    );

    expect(find.text('Products'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();
    await tester.pump();

    expect(find.text('Fake Product'), findsOneWidget);
    expect(find.text('\$9.99'), findsOneWidget);
    expect(find.text('Add to Cart'), findsOneWidget);

    await bloc.close();
  });
}