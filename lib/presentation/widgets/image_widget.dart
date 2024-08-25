import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  const ImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:FadeInImage.assetNetwork(
        image: imageUrl,
        placeholder: "assets/images/product-placeholder.png",
        imageErrorBuilder: (context, error, stackTrace) =>
            Image.asset("assets/images/product-placeholder.png"),
      ),
    );
  }
}