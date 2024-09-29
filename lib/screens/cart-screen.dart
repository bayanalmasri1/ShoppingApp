import 'package:application_store/blocs/cart-bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Shopping cart'),
        ),
        body: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return Center(child: Text('No items in cart'));
          }
          return Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: state.cartItems.length,
                      itemBuilder: (context, index) {
                        final product = state.cartItems[index];
                        return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: ListTile(
                              title: Text(product.name),
                              subtitle: Text('\$${product.price}'),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  BlocProvider.of<CartBloc>(context)
                                      .add(RemoveFromCart(product));
                                },
                              ),
                            ));
                      })),
              Padding(
                  padding: EdgeInsets.all(6),
                  child: Text(
                    'Total: \$${state.totalPrice}',
                    style: TextStyle(fontSize: 30),
                  )),
            ],
          );
        }));
  }
}
