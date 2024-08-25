
// Base class for all product events
import 'package:equatable/equatable.dart';

import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {
  final int page;
  final int limit;

  const LoadProducts({this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}

class FilterProductsByPrice extends ProductEvent {
  final double minPrice;
  final double maxPrice;

  const FilterProductsByPrice(this.minPrice, this.maxPrice);

  @override
  List<Object> get props => [minPrice, maxPrice];
}

class AddProductToCart extends ProductEvent {
  final int productId;

  const AddProductToCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class RemoveFromCart extends ProductEvent {
  final int productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}


class LoadCartProducts extends ProductEvent {
  const LoadCartProducts();
}

