import 'package:e_shop/presentation/blocs/auth/login/auth_bloc.dart';
import 'package:e_shop/presentation/pages/product/product_screen.dart';
import 'package:e_shop/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/login/auth_state.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_state.dart';
import '../cart/cart_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/splash');
        }
      },
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          toolbarHeight: 45,
          backgroundColor: const Color(0xFF527cff),
          centerTitle: true,
          title: const Text(
            "Product Home",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          // title: const Text('Shopping Home'),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 10),
              constraints: const BoxConstraints(),
              icon: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                        size: 20,
                      ),
                      if (state is CartLoaded && state.cartProducts.isNotEmpty)
                        Positioned(
                            top: -5,
                            right: -5,
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: Colors.red,
                              child: Text(state.cartProducts.length.toString(),
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.white)),
                            ))
                    ],
                  );
                },
              ),
              onPressed: () {
                // TODO: modify toast message like app toast at bottom center
                Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => const CartView()),
                );
                // showTopFlashMessage(context, ToastType.success, "Great");
                // context.push(Uri(path: "/cart").toString());
              },
            ),
          ],
        ),
        body: const ProductScreen(),
      ),
    );
  }
}
