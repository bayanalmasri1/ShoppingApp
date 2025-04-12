import 'package:application_store/Features/product/domin/model/product-list.dart';
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

class IncreaseQuantity extends CartEvent {
  final Product product;
  IncreaseQuantity(this.product);
}

class DecreaseQuantity extends CartEvent {
  final Product product;
  DecreaseQuantity(this.product);
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartState {
  final List<CartItem> cartItems;

  CartState(this.cartItems);

  double get totalPrice => double.parse(
        cartItems
            .fold(0.0, (double sum, item) => sum + (item.product.price * item.quantity))
            .toStringAsFixed(1),
      );

  int get itemCount => cartItems.fold(0, (int sum, item) => sum + item.quantity);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState([])) {
    on<AddToCart>((event, emit) {
      // Check if the product is already in the cart
      final existingItem = state.cartItems.firstWhere(
        (item) => item.product.id == event.product.id,
        orElse: () => CartItem(product: event.product),
      );

      if (state.cartItems.contains(existingItem)) {
        // If product exists, increase its quantity
        existingItem.quantity += 1;
        emit(CartState(List.from(state.cartItems)));
      } else {
        // If it's a new product, add it to the cart
        emit(CartState([...state.cartItems, CartItem(product: event.product)]));
      }
    });

    on<RemoveFromCart>((event, emit) {
      // Remove the product from the cart
      emit(CartState(state.cartItems.where((item) => item.product.id != event.product.id).toList()));
    });

    on<IncreaseQuantity>((event, emit) {
      // Find the product and increase its quantity
      final item = state.cartItems.firstWhere((item) => item.product.id == event.product.id);
      item.quantity += 1;
      emit(CartState(List.from(state.cartItems)));
    });

    on<DecreaseQuantity>((event, emit) {
      // Find the product and decrease its quantity if greater than 1
      final item = state.cartItems.firstWhere((item) => item.product.id == event.product.id);
      if (item.quantity > 1) {
        item.quantity -= 1;
        emit(CartState(List.from(state.cartItems)));
      } else {
        // If the quantity reaches 1 and user tries to decrease, remove the item from the cart
        emit(CartState(state.cartItems.where((i) => i.product.id != event.product.id).toList()));
      }
    });
  }
}
