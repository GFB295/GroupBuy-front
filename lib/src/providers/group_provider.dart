import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group.dart';
import '../services/api_service.dart';

final groupProvider = StateNotifierProvider<GroupNotifier, AsyncValue<List<Group>>>((ref) => GroupNotifier());

class GroupNotifier extends StateNotifier<AsyncValue<List<Group>>> {
  GroupNotifier() : super(const AsyncValue.loading()) {
    loadGroups();
  }

  final ApiService _api = ApiService();

  Future<void> loadGroups() async {
    try {
      state = const AsyncValue.loading();
      final data = await _api.fetchActiveGroups();
      final groups = data.map<Group>((g) => Group.fromJson(g)).toList();
      state = AsyncValue.data(groups);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> joinGroup(String groupId, String paymentMethod) async {
    try {
      final result = await _api.joinGroup(groupId, paymentMethod);
      // Recharger les groupes après avoir rejoint
      await loadGroups();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshGroups() async {
    await loadGroups();
  }
}