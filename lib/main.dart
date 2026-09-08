import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/local/hive_service.dart';
import 'data/repositories/product_repository.dart';
import 'presentation/bloc/bloc/products_bloc.dart';
import 'presentation/screens/product_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  runApp(const OrderPlacementApp());
}

class OrderPlacementApp extends StatelessWidget {
  const OrderPlacementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Placement',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF14B8A6)),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          surfaceTintColor: Colors.transparent,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ProductsBloc>(
            create: (_) => ProductsBloc(ProductRepository()),
          ),
        ],
        child: const ProductScreen(),
      ),
    );
  }
}