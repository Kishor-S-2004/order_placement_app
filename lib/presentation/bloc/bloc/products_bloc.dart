import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_placement_app/data/model/product_model.dart';
import 'package:order_placement_app/data/repositories/product_repository.dart';
import 'package:order_placement_app/data/local/hive_service.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository productRepository;
  ProductsBloc(this.productRepository) : super(ProductsInitial()) {
    on<FetchProductDetails>((event, emit) async {
      emit(ProductsLoading());
      try {
        final cachedProducts = HiveService.getProducts();
        if (cachedProducts.isNotEmpty) {
          emit(ProductSuccess(cachedProducts));
          return;
        }
        final products = await productRepository.fetchProducts();
        await HiveService.saveProducts(products);
        emit(ProductSuccess(products));
      } catch (e) {
        emit(ProductsError(e.toString()));
      }
    });
  }
}
