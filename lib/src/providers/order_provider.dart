import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../services/order_service.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, AsyncValue<List<Order>>>(
      (ref) => OrderNotifier(),
);

class OrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  OrderNotifier() : super(const AsyncValue.loading()) {
    loadOrders();
  }

  final OrderService _api = OrderService();

  Future<void> loadOrders() async {
    try {
      state = const AsyncValue.loading();
      final data = await _api.fetchOrders();
      final orders = data.map((o) => Order.fromJson(o)).toList();
      state = AsyncValue.data(orders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }
}
