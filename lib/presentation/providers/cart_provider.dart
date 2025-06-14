import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplet/data/models/cart_item_model.dart';
import 'package:zaplet/data/models/product_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(Product product, [int quantity = 1]) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      state = [
        ...state.sublist(0, existingIndex),
        state[existingIndex].copyWith(quantity: state[existingIndex].quantity + quantity),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final existingIndex = state.indexWhere((item) => item.product.id == productId);
    if (existingIndex >= 0) {
      state = [
        ...state.sublist(0, existingIndex),
        state[existingIndex].copyWith(quantity: quantity),
        ...state.sublist(existingIndex + 1),
      ];
    }
  }

  void clearCart() {
    state = [];
  }

  double get totalPrice => state.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
} 