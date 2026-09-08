part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

class FetchProductDetails extends ProductsEvent{}
