import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]);

  // Ajouter une nouvelle commande
  void addOrder(Order order) {
    state = [...state, order];
  }

  // Obtenir le nombre total de commandes
  int getTotalOrders() {
    return state.length;
  }

  // Obtenir le montant total dépensé
  double getTotalSpent() {
    return state.fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  // Obtenir les commandes récentes
  List<Order> getRecentOrders({int limit = 5}) {
    return state.take(limit).toList();
  }

  // Vider l'historique (pour les tests)
  void clearHistory() {
    state = [];
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
  return OrderNotifier();
});
