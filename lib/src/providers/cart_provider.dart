import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) => CartNotifier());

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // Ajouter un produit au panier
  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);
    
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
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        quantity: quantity,
        price: product.groupPrice,
        addedAt: DateTime.now(),
      );
      
      state = [...state, newItem];
    }
  }

  // Retirer un produit du panier
  void removeFromCart(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  // Mettre à jour la quantité d'un produit
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final newState = state.map((item) {
      if (item.product.id == productId) {
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
  
  double get totalPrice => state.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  double get totalSavings => state.fold(0.0, (sum, item) => sum + item.savings);
  
  bool get isEmpty => state.isEmpty;
  
  bool get isNotEmpty => state.isNotEmpty;

  // Vérifier si un produit est dans le panier
  bool isInCart(String productId) {
    return state.any((item) => item.product.id == productId);
  }

  // Obtenir la quantité d'un produit dans le panier
  int getQuantity(String productId) {
    final item = state.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        id: '',
        product: Product(
          id: '',
          name: '',
          description: '',
          category: '',
          individualPrice: 0,
          groupPrice: 0,
          imageUrl: '',
          requiredParticipants: 0,
          currentParticipants: 0,
          isActive: true,
          endDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        quantity: 0,
        price: 0,
        addedAt: DateTime.now(),
      ),
    );
    return item.quantity;
  }
} 