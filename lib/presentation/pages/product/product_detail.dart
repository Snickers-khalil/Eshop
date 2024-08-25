import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/product.dart';
import '../../widgets/add_to_cart_button.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? 'Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display product image
            if (product.images != null && product.images!.isNotEmpty)
              FadeInImage.assetNetwork(
                image: product.images!.first,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
                placeholder: "assets/images/product-placeholder.png",
                imageErrorBuilder: (context, error, stackTrace) =>
                    Image.asset("assets/images/product-placeholder.png"),
              ),

            const SizedBox(height: 16),
            Text(
              product.title ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Display price and discount
            Row(
              children: [
                Text(
                  '\$${product.price?.toStringAsFixed(2) ?? ''}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                if (product.price != null && product.price! < 50)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.discountPercentage != null
                          ? '${product.discountPercentage}% Off'
                          : 'Promotion',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                const SizedBox(width: 8),
                if (product.price != null && product.price! < 10)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Vente Flash',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Display product description
            Text(
              product.description ?? '',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Add to cart button
            Align(
              alignment: Alignment.centerRight,
              child: AddToCartButton(productItem: product),
            ),
          ],
        ),
      ),
    );
  }
}
