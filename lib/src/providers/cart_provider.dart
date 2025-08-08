import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) => CartNotifier());

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // Ajouter un produit au panier
  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = state.indexWhere((item) => item.id == product.id);
    if (existingIndex >= 0) {
      // Produit déjà dans le panier, augmenter la quantité
      final existingItem = state[existingIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
      final newState = List<CartItem>.from(state);
      newState[existingIndex] = updatedItem;
      state = newState;
    } else {
      // Nouveau produit
      final newItem = CartItem(
        id: product.id,
        name: product.name,
        variant: product.category, // ou autre champ pour la variante
        imageUrl: product.imageUrl,
        price: product.groupPrice,
        oldPrice: product.individualPrice,
        quantity: quantity,
      );
      state = [...state, newItem];
    }
  }

  // Retirer un produit du panier
  void removeFromCart(String productId) {
    state = state.where((item) => item.id != productId).toList();
  }

  // Mettre à jour la quantité d'un produit
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final newState = state.map((item) {
      if (item.id == productId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();
    state = newState;
  }

  // Vider le panier
  void clearCart() {
    state = [];
  }

  // Propriétés calculées
  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => state.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  double get totalSavings => state.fold(0.0, (sum, item) => sum + ((item.oldPrice ?? item.price) - item.price) * item.quantity);
  bool get isEmpty => state.isEmpty;
  bool get isNotEmpty => state.isNotEmpty;

  // Vérifier si un produit est dans le panier
  bool isInCart(String productId) {
    return state.any((item) => item.id == productId);
  }

  // Obtenir la quantité d'un produit dans le panier
  int getQuantity(String productId) {
    final item = state.firstWhere(
      (item) => item.id == productId,
      orElse: () => CartItem(
        id: '',
        name: '',
        variant: '',
        imageUrl: '',
        price: 0,
        oldPrice: 0,
        quantity: 0,
      ),
    );
    return item.quantity;
  }
} 