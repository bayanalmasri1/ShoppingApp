import 'package:application_store/model/product-list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  AddToCart(this.product);
}


class RemoveFromCart extends CartEvent {
  final Product product;
  RemoveFromCart(this.product);
}

class CartState {
  final List<Product> cartItems;
  CartState(this.cartItems);

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.price);
  int get itemCount => cartItems.length;
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState([])) {
    on<AddToCart>((event, emit) {
      emit(CartState([...state.cartItems, event.product]));
    });
    on<RemoveFromCart>((event, emit) {
      emit(CartState([...state.cartItems]..remove(event.product)));
    });
  }
}