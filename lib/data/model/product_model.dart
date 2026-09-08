  import 'package:hive_flutter/hive_flutter.dart';

  part 'product_model.g.dart';

  @HiveType(typeId : 1)
  class ProductModel {
    ProductModel({
      required this.productId,
      required this.productName,
      required this.price,
      required this.imageUrl,
    });


    @HiveField(0)
    int productId;

    @HiveField(1)
    String productName;

    @HiveField(2)
    double price;

    @HiveField(3)
    String imageUrl;

     factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['id'] as int? ?? 0,
      productName: json['title'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['thumbnail'] as String? ?? '',
    );
  }
  }
