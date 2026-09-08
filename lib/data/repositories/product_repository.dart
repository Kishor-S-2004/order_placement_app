// import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:order_placement_app/data/model/product_model.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final productApi = 'https://dummyjson.com/products';

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final url = Uri.parse(productApi);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = data['products'] as List;

        return products.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
