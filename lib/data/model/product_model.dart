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
  }
