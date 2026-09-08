import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_placement_app/data/model/product_model.dart';
import 'package:order_placement_app/data/model/cart_model.dart';
import 'package:order_placement_app/data/model/product_model.dart';

import '../../../data/local/hive_service.dart';
import '../../../data/model/cart_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
      on<FetchCartItems>((event, emit) {
      try {
        emit(CartLoading());

        final cartItems = HiveService.getCart();

        emit(CartSuccess(cartItems));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });
    
      on<AddToCart>((event, emit) async {
      try {
        final currentCart = HiveService.getCart();

        final existingItem = currentCart.where(
          (item) => item.productId == event.product.productId,
        );

        if (existingItem.isNotEmpty) {
          final item = existingItem.first;

          item.quantity++;

          await HiveService.saveCartItem(item);
        } else {
          final cartItem = CartModel(
            productId: event.product.productId,
            productName: event.product.productName,
            price: event.product.price,
            imageUrl: event.product.imageUrl,
            quantity: 1,
          );

          await HiveService.saveCartItem(cartItem);
        }

        final updatedCart = HiveService.getCart();

        emit(CartSuccess(updatedCart));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<UpdateCartQuantity>((event, emit) async {
      try {
        if (event.quantity <= 0) {
          await HiveService.removeCartItem(event.productId);
        } else {
          final currentCart = HiveService.getCart();

          final item = currentCart.firstWhere(
            (item) => item.productId == event.productId,
          );

          item.quantity = event.quantity;

          await HiveService.saveCartItem(item);
        }

        final updatedCart = HiveService.getCart();

        emit(CartSuccess(updatedCart));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<RemoveCartItem>((event, emit) async {
      try {
        await HiveService.removeCartItem(event.productId);

        final updatedCart = HiveService.getCart();

        emit(CartSuccess(updatedCart));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });
  }
}

