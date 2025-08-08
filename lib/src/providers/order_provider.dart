import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../models/product.dart';

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]) {
    _initializeDemoData();
  }

  void _initializeDemoData() {
    // Données de démonstration pour tester les différents états
    final demoOrders = [
      Order(
        id: 'order1',
        userId: 'user1',
        items: [
          OrderItem(
            productId: 'prod1',
            productName: 'Sac African TotBag',
            quantity: 1,
            price: 15000,
          ),
        ],
        totalAmount: 15000,
        status: 'confirmed',
        deliveryStatus: 'shipped',
        trackingNumber: 'TRK123456789',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        estimatedDelivery: DateTime.now().add(const Duration(hours: 2)),
      ),
      Order(
        id: 'order2',
        userId: 'user1',
        items: [
          OrderItem(
            productId: 'prod2',
            productName: 'AirPods Max',
            quantity: 1,
            price: 250000,
          ),
          OrderItem(
            productId: 'prod3',
            productName: 'Clavier Sans Fil',
            quantity: 2,
            price: 45000,
          ),
        ],
        totalAmount: 340000,
        status: 'confirmed',
        deliveryStatus: 'preparing',
        trackingNumber: 'TRK987654321',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        estimatedDelivery: DateTime.now().add(const Duration(days: 1)),
      ),
      Order(
        id: 'order3',
        userId: 'user1',
        items: [
          OrderItem(
            productId: 'prod4',
            productName: 'Chaussure Adidas',
            quantity: 1,
            price: 75000,
          ),
        ],
        totalAmount: 75000,
        status: 'confirmed',
        deliveryStatus: 'delivered',
        trackingNumber: 'TRK456789123',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        actualDelivery: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    state = demoOrders;
  }

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

  // Réinitialiser avec les données de démonstration
  void resetToDemoData() {
    _initializeDemoData();
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
  return OrderNotifier();
});
