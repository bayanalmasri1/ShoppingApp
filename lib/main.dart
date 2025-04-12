import 'package:application_store/Features/product/presentation/blocs/cart-bloc.dart';
import 'package:application_store/Features/product/presentation/blocs/product-bloc.dart';
import 'package:application_store/Features/product/data/repository/product-api.dart';
import 'package:application_store/Features/product/presentation/screens/cart-screen.dart';
import 'package:application_store/Features/product/presentation/screens/product-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final ProductApi productApi = ProductApi();


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
        create: (context) => ProductBloc(productRepository: productApi)..add(LoadProducts()),
        ),
        BlocProvider(create: (context)=> CartBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping App',
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: {
          "/":(context )=> ProductScreen(),
          "/cart":(context) => CartScreen()
        },
      ),
    );
  }
}

