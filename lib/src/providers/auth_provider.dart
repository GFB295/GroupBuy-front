import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);

  void login(String email, String password) {
    // Mock login
    state = User(id: 'u1', name: 'Alice', email: email);
  }

  void register(String name, String email, String password) {
    // Mock register
    state = User(id: 'u2', name: name, email: email);
  }

  void logout() {
    state = null;
  }
} 