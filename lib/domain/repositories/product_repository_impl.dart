import 'dart:convert';
import 'package:e_shop/domain/repositories/product_repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final String baseUrl = 'https://dummyjson.com/products';

  @override
  Future<List<Product>> getProducts({int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body)['products'];
        // final jsonResponse = json.decode(response.body);
        print('Parsed JSON: $jsonResponse');
        final List<dynamic> productList = jsonResponse;
        return productList.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Failed to load products. Status code: ${response.statusCode}');
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error in getProducts: $error');
      throw Exception('Failed to load products');
    }
  }

  // @override
  // Future<List<Product>> getProducts({int page = 1, int limit = 10}) async {
  //   final response = await http.get(Uri.parse(baseUrl));
  //   print(response.statusCode);
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     final List<dynamic> productList = json.decode(response.body);
  //     return productList.map((json) => Product.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?q=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> productList = json.decode(response.body)['products'];
      return productList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }

  @override
  Future<List<Product>> filterProductsByPrice(double minPrice, double maxPrice) async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      final List<dynamic> productList = json.decode(response.body)['products'];
      return productList
          .map((json) => Product.fromJson(json))
          .where((product) => product.price! >= minPrice && product.price! <= maxPrice)
          .toList();
    } else {
      throw Exception('Failed to filter products');
    }
  }

  @override
  Future<Product> getProductDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product details');
    }
  }

  @override
  Future<void> addToCart(Product product) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cartString = prefs.getString('cart');
    List<Product> cart = cartString != null
        ? List<Product>.from(
        json.decode(cartString).map((item) => Product.fromJson(item)))
        : [];

    cart.add(product);

    final String updatedCartString = json.encode(cart.map((e) => e.toJson()).toList());
    await prefs.setString('cart', updatedCartString);

    print('Product added to cart: ${product.title}');
  }

  @override
  Future<List<Product>> getCartProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cartString = prefs.getString('cart');

    if (cartString != null) {
      List<Product> cart = List<Product>.from(
          json.decode(cartString).map((item) => Product.fromJson(item)));
      return cart;
    }
    return [];
  }

  Future<void> removeFromCart(int productId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cartString = prefs.getString('cart');
    if (cartString != null) {
      List<Product> cart = List<Product>.from(
          json.decode(cartString).map((item) => Product.fromJson(item)));

      cart.removeWhere((product) => product.id == productId);

      final String updatedCartString = json.encode(cart.map((e) => e.toJson()).toList());
      await prefs.setString('cart', updatedCartString);
    }
  }

}
