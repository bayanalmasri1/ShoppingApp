import 'package:application_store/model/product-list.dart';
import 'package:application_store/repository/product-api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProductEvent {}
class LoadProducts extends ProductEvent {}

abstract class ProductState {}
class ProductLoading extends ProductState {}
class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
}
class ProductError extends ProductState {}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductApi productRepository;

  ProductBloc({required this.productRepository}) : super(ProductLoading()) {
    on<LoadProducts>((event, emit) async {
      try {
        final products = await productRepository.fetchProducts();
        emit(ProductLoaded(products));
      } catch (_) {
        emit(ProductError());
      }
    });
  }
}