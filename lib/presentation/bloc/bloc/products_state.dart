part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductSuccess extends ProductsState {
  final List<ProductModel> productDetails;
  ProductSuccess(this.productDetails);
}

final class ProductsError extends ProductsState {
  final String errorMessage;
  ProductsError(this.errorMessage);
}

