import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplet/data/models/product_model.dart';

final productLoadingProvider = StateProvider<bool>((ref) => true);

final productProvider = Provider<List<Product>>((ref) {
  // Simulate loading delay
  Future.delayed(const Duration(seconds: 1), () {
    ref.read(productLoadingProvider.notifier).state = false;
  });
  return Product.getMockProducts();
});

final featuredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productProvider);
  return products.where((product) => product.isFeatured).toList();
});

final newArrivalsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productProvider);
  return products.where((product) => product.isNew).toList();
});

final productsByCategoryProvider = Provider.family<List<Product>, String>((ref, category) {
  final products = ref.watch(productProvider);
  return products.where((product) => product.category == category).toList();
}); 