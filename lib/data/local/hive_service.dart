import 'package:hive_flutter/hive_flutter.dart';
import 'package:order_placement_app/data/model/product_model.dart';

class HiveService {
  static const String productsBoxName = 'products';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ProductModelAdapter());

    await Hive.openBox<ProductModel>(productsBoxName);
  }

  // static Future<void> saveProducts(
  //   List<ProductModel> products,
  // ) async {
  //   final box = Hive.box<ProductModel>(productsBoxName);

  //   await box.clear();

  //   await box.addAll(products);
  // }

static Future<void> saveProducts(
  List<ProductModel> products,
) async {
  final box = Hive.box<ProductModel>(productsBoxName);

  await box.clear();
  await box.addAll(products);

  print('Products saved to Hive: ${box.length}');
}

  // static List<ProductModel> getProducts() {
  //   final box = Hive.box<ProductModel>(productsBoxName);

  //   return box.values.toList();
  // }

  static List<ProductModel> getProducts() {
  final box = Hive.box<ProductModel>(productsBoxName);

  print('Products loaded from Hive: ${box.length}');

  return box.values.toList();
}
}

