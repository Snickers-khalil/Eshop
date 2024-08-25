import '../../data/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int page = 1, int limit = 10});
  Future<List<Product>> searchProducts(String query);
  Future<List<Product>> filterProductsByPrice(double minPrice, double maxPrice);
  Future<Product> getProductDetails(int id);
  Future<void> addToCart(Product product);
  Future<List<Product>> getCartProducts();
}

