import 'package:hive_flutter/hive_flutter.dart';
import 'package:order_placement_app/data/model/product_model.dart';
import 'package:order_placement_app/data/model/cart_model.dart';

class HiveService {
  static const String productsBoxName = 'products';
  static const String cartBoxName = 'cart';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(CartModelAdapter());

    await Hive.openBox<ProductModel>(productsBoxName);
    await Hive.openBox<CartModel>(cartBoxName);
  }

  static Future<void> saveProducts(List<ProductModel> products) async {
    final box = Hive.box<ProductModel>(productsBoxName);

    await box.clear();
    await box.addAll(products);

    print('Products saved to Hive: ${box.length}');
  }

  static List<ProductModel> getProducts() {
    final box = Hive.box<ProductModel>(productsBoxName);

    print('Products loaded from Hive: ${box.length}');

    return box.values.toList();
  }

  static List<CartModel> getCart() {
    final box = Hive.box<CartModel>(cartBoxName);

    return box.values.toList();
  }

  static Future<void> saveCartItem(CartModel cartItem) async {
    final box = Hive.box<CartModel>(cartBoxName);

    await box.put(cartItem.productId, cartItem);
  }

  static Future<void> removeCartItem(int productId) async {
    final box = Hive.box<CartModel>(cartBoxName);

    await box.delete(productId);
  }

  static Future<void> clearCart() async {
    final box = Hive.box<CartModel>(cartBoxName);

    await box.clear();
  }
}
