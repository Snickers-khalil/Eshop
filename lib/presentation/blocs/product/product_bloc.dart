import 'package:e_shop/domain/repositories/product_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepositoryImpl productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<LoadProducts>(onLoadProducts);
    on<SearchProducts>(onSearchProducts);
    on<FilterProductsByPrice>(onFilterProductsByPrice);
    on<AddProductToCart>(onAddProductToCart);
    on<LoadCartProducts>(onLoadCartProducts);
    on<RemoveFromCart>(onRemoveFromCart);  // Add the remove event handler
  }

  Future<void> onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.getProducts(page: event.page, limit: event.limit);
      emit(ProductLoaded(products));
    } catch (e) {
      print('Bloc error: $e');
      emit(ProductError('Failed to load products: $e'));
    }
  }

  Future<void> onSearchProducts(SearchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.searchProducts(event.query);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> onFilterProductsByPrice(FilterProductsByPrice event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.filterProductsByPrice(event.minPrice, event.maxPrice);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> onAddProductToCart(AddProductToCart event, Emitter<ProductState> emit) async {
    try {
      final product = await productRepository.getProductDetails(event.productId);
      await productRepository.addToCart(product);
      final cartProducts = await productRepository.getCartProducts();
      emit(CartLoaded(cartProducts));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
  Future<void> onLoadCartProducts(LoadCartProducts event, Emitter<ProductState> emit) async {
    try {
      final cartProducts = await productRepository.getCartProducts();
      emit(CartLoaded(cartProducts));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> onRemoveFromCart(RemoveFromCart event, Emitter<ProductState> emit) async {
    try {
      await productRepository.removeFromCart(event.productId);
      final cartProducts = await productRepository.getCartProducts();
      emit(CartLoaded(cartProducts));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}

