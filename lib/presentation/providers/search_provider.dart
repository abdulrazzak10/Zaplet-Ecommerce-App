import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplet/data/models/product_model.dart';
import 'package:zaplet/presentation/providers/product_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final products = ref.watch(productProvider);

  if (query.isEmpty) {
    return products;
  }

  return products.where((product) {
    return product.name.toLowerCase().contains(query) ||
        product.description.toLowerCase().contains(query) ||
        product.category.toLowerCase().contains(query);
  }).toList();
}); 