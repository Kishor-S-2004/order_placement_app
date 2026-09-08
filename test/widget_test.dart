import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:order_placement_app/main.dart';

void main() {
  testWidgets('renders product listing with cart badge', (tester) async {
    await tester.pumpWidget(const OrderPlacementApp());

    expect(find.text('Products'), findsOneWidget);
    expect(find.text('Product Name'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    expect(find.text('Add to Cart'), findsNWidgets(4));
  });
}