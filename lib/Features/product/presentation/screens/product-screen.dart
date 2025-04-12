import 'package:application_store/Features/product/presentation/blocs/cart-bloc.dart';
import 'package:application_store/Features/product/presentation/blocs/product-bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // Variable to hold the index of the product being animated
  int? _animatedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
          actions: [
            BlocBuilder<CartBloc, CartState>(builder: (context, cartState) {
              return IconButton(
                icon: Stack(
                  children: [
                    Icon(Icons.shopping_cart_rounded),
                    if (cartState.itemCount > 0)
                      Positioned(
                        right: 0,
                        child: AnimatedOpacity(
                          opacity: cartState.itemCount > 0 ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              maxWidth: 20,
                              maxHeight: 20,
                            ),
                            child: Text(
                              '${cartState.itemCount}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              );
            })
          ],
        ),
        body: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (state is ProductLoaded) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.75),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    bool isAnimating = _animatedIndex == index;
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isAnimating
                            ? Colors.green.withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                          color: isAnimating ? Colors.green : Colors.grey,
                          width: isAnimating ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(product.name,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('${product.price}')),
                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: isAnimating
                                          ? Colors.purple
                                          : Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _animatedIndex = index;
                                    });
                                    BlocProvider.of<CartBloc>(context)
                                        .add(AddToCart(product));

                                    Future.delayed(Duration(seconds: 1), () {
                                      setState(() {
                                        _animatedIndex = null;
                                      });
                                    });
                                  },
                                  child: Text("Add To Cart")),
                            ],
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return Center(child: Text('Failed to load products'));
            }
          }
        }));
  }
}
