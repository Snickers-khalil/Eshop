import 'package:e_shop/presentation/blocs/product/product_bloc.dart';
import 'package:e_shop/presentation/blocs/product/product_event.dart';
import 'package:e_shop/presentation/pages/cart/cart_screen.dart';
import 'package:e_shop/presentation/widgets/app_drawer.dart';
import 'package:e_shop/presentation/widgets/no_data_screen.dart';
import 'package:e_shop/presentation/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../data/models/product.dart';
import '../../blocs/product/product_state.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  static const _pageSize = 10;
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1);
  final List<Product> _allProducts = []; // Local list to store all products

  // Store search query and filter values
  String _searchQuery = '';
  double _minPrice = 0;
  double _maxPrice = 100;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadCartProducts());
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems =
          await context.read<ProductBloc>().productRepository.getProducts(
                page: pageKey,
                limit: _pageSize,
              );

      // Filter the new items based on search and price criteria
      final filteredItems = newItems.where((product) {
        final matchesQuery =
            product.title!.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesPrice =
            product.price! >= _minPrice && product.price! <= _maxPrice;
        return matchesQuery && matchesPrice;
      }).toList();

      final isLastPage = filteredItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(filteredItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(filteredItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _searchQuery = '';
      _minPrice = 0;
      _maxPrice = 100;
    });
    // Refresh the paging controller
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: PagedGridView<int, Product>(
          pagingController: _pagingController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          builderDelegate: PagedChildBuilderDelegate<Product>(
            itemBuilder: (context, product, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductTile(product: product),
            ),
            firstPageErrorIndicatorBuilder: (context) => const Center(
              child: Text('Erreur lors du chargement des produits.'),
            ),
            noItemsFoundIndicatorBuilder: (context) => const NoDataFoundScreen(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterDialog(context),
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Initialize the filter values
            String searchQuery = _searchQuery;
            double minPrice = _minPrice;
            double maxPrice = _maxPrice;

            return AlertDialog(
              title: const Text('Filter Products'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Search'),
                      controller: TextEditingController(text: searchQuery),
                      onChanged: (value) {
                        searchQuery = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    RangeSlider(
                      min: 0,
                      max: 100,
                      // Set a reasonable max value for your use case
                      values: RangeValues(minPrice, maxPrice),
                      onChanged: (values) {
                        setState(() {
                          _minPrice = values.start;
                          _maxPrice = values.end;
                        });
                      },
                      labels: RangeLabels(
                        _minPrice.toString(),
                        _maxPrice.toString(),
                      ),
                    ),
                    Text(_minPrice.toStringAsFixed(2)),
                    Text(_maxPrice.toStringAsFixed(2)),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    // Apply the filters when Apply is pressed
                    setState(() {
                      _searchQuery = searchQuery;
                      _minPrice = minPrice;
                      _maxPrice = maxPrice;
                      _pagingController.refresh(); // Trigger pagination refresh
                    });
                  },
                  child: const Text('Apply'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}