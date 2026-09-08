part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class FetchCartItems extends CartEvent {}

class AddToCart extends CartEvent {
  final ProductModel product;

  AddToCart(this.product);
}

class UpdateCartQuantity extends CartEvent {
  final int productId;
  final int quantity;

  UpdateCartQuantity({
    required this.productId,
    required this.quantity,
  });
}

class RemoveCartItem extends CartEvent {
  final int productId;

  RemoveCartItem(this.productId);
}