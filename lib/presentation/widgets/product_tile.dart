import 'package:e_shop/data/models/product.dart';
import 'package:e_shop/presentation/blocs/product/product_bloc.dart';
import 'package:e_shop/presentation/blocs/product/product_event.dart';
import 'package:e_shop/presentation/blocs/product/product_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/product/product_detail.dart';
import 'add_to_cart_button.dart';
import 'image_widget.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // final creationDate = product.creationDate;
    // final isNew = now.difference(creationDate).inDays <= 3;
    return InkWell(
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product:product,)),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 320,
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
              border: Border.all(
                color: Colors.grey.withOpacity(0.3), // Border color
                width: 1.0, // Border width
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 4, // Blur radius
                  offset: const Offset(0, 3), // Offset
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInImage.assetNetwork(
                  image: product.images!.first,
                  width: 220,
                  height: 100,
                  fit: BoxFit.fill,
                  placeholder: "assets/images/product-placeholder.png",
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Image.asset("assets/images/product-placeholder.png"),
                ),
                // Image.network(product.images!.first,width: 200,height: 100,fit: BoxFit.contain,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.title!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('${product.price} \$'),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 8,
              right: 8,
              child: AddToCartButton(productItem: product),
          ),
          // Promotion Label
          if (product.price! < 50 && product.discountPercentage != null)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                color: Colors.red,
                child: Text('${product.discountPercentage}%'),
              ),
            ),
          const SizedBox(width: 5),
          // Flash Sale Label
          if (product.price! < 10)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                color: Colors.orange,
                child: const Text('Vente Flash'),
              ),
            ),
        ],
      ),
    );
  }
}
// class AddToCartButton extends StatelessWidget {
//   const AddToCartButton({
//     super.key,
//     required this.productItem,
//   });
//
//   final Product productItem;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProductBloc, ProductState>(
//       builder: (context, state) {
//         if (state is ProductLoading) {
//           return const SizedBox();
//         } else if (state is ProductError) {
//           if (kDebugMode) {
//             print('cart error');
//           }
//           return const SizedBox();
//         } else if (state is CartLoaded) {
//           final isInCart = state.cartProducts
//               .map((e) => e.id)
//               .any((element) => element == productItem.id);
//           return IconButton(
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(),
//             splashRadius: 20,
//             icon: Icon(
//               isInCart ? Icons.check : Icons.shopping_cart,
//               color: Colors.black,
//               size: 22,
//             ),
//             onPressed: () {
//               if (!isInCart) {
//                 context.read<ProductBloc>().add(AddProductToCart(productItem.id));
//               }
//             },
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }
// }

// class AddToCartButton extends StatelessWidget {
//   const AddToCartButton({
//     super.key,
//     required this.productItem,
//   });
//
//   final Product productItem;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProductBloc, ProductState>(
//       builder: (context, state) {
//         if (state is ProductLoading) {
//           return const SizedBox();
//         }
//         if (state is ProductError) {
//           if (kDebugMode) {
//             print('cart error');
//           }
//           return const SizedBox();
//         }
//         if (state is CartLoaded) {
//           final isInCart = state.cartProducts
//               .map((e) => e.id)
//               .any((element) => element == productItem.id);
//
//           return IconButton(
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(),
//             splashRadius: 20,
//             icon: Icon(
//               isInCart ? Icons.check : Icons.shopping_cart,
//               color: Colors.black,
//               size: 22,
//             ),
//             onPressed: () {
//               if (isInCart == false) {
//                 context.read<ProductBloc>().add(AddProductToCart( CartItemTblData(
//                   id: productItem.id,
//                   title: productItem.title,
//                   createdAt: DateTime.now(),
//                   featuredImage: productItem.thumbnail,
//                   price: productItem.price.toDouble(),
//                   description: productItem.description,
//                 )));
//               }
//             },
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }
///
// class ProductTile extends StatelessWidget {
//   final Product product;
//   const ProductTile({Key? key, required this.product})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       decoration:
//       BoxDecoration(border: Border.all(color: Colors.grey, width: 0.02)),
//       height: size.height,
//       width: size.width,
//       child: ListView(
//         physics: const NeverScrollableScrollPhysics(),
//         children: [
//           ImageWidget(imageUrl: product.images!.first),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.only(left: 20),
//             child: Text('\$ ${product.price!.toString()}',
//                 style:
//                 const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20),
//             child: Text(product.title!,
//                 style: const TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w600)),
//           ),
//         ],
//       ),
//     );
//   }
// }