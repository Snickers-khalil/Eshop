

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.productItem,
  });

  final Product productItem;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const SizedBox();
        } else if (state is ProductError) {
          if (kDebugMode) {
            print('cart error');
          }
          return const SizedBox();
        } else if (state is CartLoaded) {
          final isInCart = state.cartProducts
              .map((e) => e.id)
              .any((element) => element == productItem.id);
          return IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
            icon: Icon(
              isInCart ? Icons.check : Icons.shopping_cart,
              color: Colors.black,
              size: 22,
            ),
            onPressed: () {
              if (!isInCart) {
                context.read<ProductBloc>().add(AddProductToCart(productItem.id));
              }
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
