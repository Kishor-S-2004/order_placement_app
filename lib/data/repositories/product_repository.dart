import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:order_placement_app/data/model/product_model.dart';

class ProductRepository {
  final String productApi = 'https://dummyjson.com/products';

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final url = Uri.parse(productApi);
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to load products: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['products'] as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
