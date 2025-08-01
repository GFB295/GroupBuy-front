import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification.dart';
import '../services/api_service.dart';

final notificationProvider = StateNotifierProvider<NotificationNotifier, AsyncValue<Map<String, dynamic>>>((ref) => NotificationNotifier());

class NotificationNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  NotificationNotifier() : super(const AsyncValue.loading()) {
    loadNotifications();
  }

  final ApiService _api = ApiService();

  Future<void> loadNotifications({
    bool? isRead,
    String? type,
    int limit = 20,
    int page = 1,
  }) async {
    try {
      state = const AsyncValue.loading();
      final data = await _api.fetchNotifications(
        isRead: isRead,
        type: type,
        limit: limit,
        page: page,
      );
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _api.markNotificationAsRead(notificationId);
      // Recharger les notifications après la mise à jour
      await loadNotifications();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      // Simuler la marque de toutes les notifications comme lues
      // En réalité, il faudrait appeler une API pour marquer toutes comme lues
      await loadNotifications();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshNotifications() async {
    await loadNotifications();
  }

  List<Notification> get notifications {
    final data = state.value;
    if (data != null && data['notifications'] != null) {
      return (data['notifications'] as List)
          .map((n) => Notification.fromJson(n))
          .toList();
    }
    return [];
  }

  int get unreadCount {
    final data = state.value;
    return data?['unreadCount'] ?? 0;
  }
} 