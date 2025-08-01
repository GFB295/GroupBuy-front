import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Product>>((ref) => FavoritesNotifier());

class FavoritesNotifier extends StateNotifier<List<Product>> {
  FavoritesNotifier() : super([]);

  // Ajouter aux favoris
  void addToFavorites(Product product) {
    if (!isInFavorites(product.id)) {
      state = [...state, product];
    }
  }

  // Retirer des favoris
  void removeFromFavorites(String productId) {
    state = state.where((product) => product.id != productId).toList();
  }

  // Vérifier si un produit est dans les favoris
  bool isInFavorites(String productId) {
    return state.any((product) => product.id == productId);
  }

  // Vider les favoris
  void clearFavorites() {
    state = [];
  }

  // Propriétés calculées
  int get count => state.length;
  bool get isEmpty => state.isEmpty;
  bool get isNotEmpty => state.isNotEmpty;
} 