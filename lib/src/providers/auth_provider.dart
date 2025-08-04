import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<User?> {
  final AuthService _authService = AuthService();
  
  AuthNotifier() : super(null);

  Future<void> login(String email, String password) async {
    try {
      print('🔐 AuthProvider: Tentative de connexion...');
      
      // Test de connexion d'abord
      final isConnected = await _authService.testConnection();
      if (!isConnected) {
        throw Exception('Serveur inaccessible. Vérifiez que le serveur Node.js est démarré.');
      }
      
      final response = await _authService.login(email, password);
      
      if (response != null && response['user'] != null) {
        final userData = response['user'];
        state = User(
          id: userData['id'] ?? userData['_id'] ?? 'unknown',
          name: userData['name'] ?? 'Utilisateur',
          email: userData['email'] ?? email,
          role: userData['role'] ?? 'client',
        );
        print('✅ AuthProvider: Connexion réussie');
      } else {
        throw Exception('Réponse invalide du serveur');
      }
    } catch (e) {
      print('❌ AuthProvider: Erreur de connexion: $e');
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      print('📝 AuthProvider: Tentative d\'inscription...');
      
      // Test de connexion d'abord
      final isConnected = await _authService.testConnection();
      if (!isConnected) {
        throw Exception('Serveur inaccessible. Vérifiez que le serveur Node.js est démarré.');
      }
      
      final response = await _authService.register(name, email, password);
      
      if (response != null && response['user'] != null) {
        final userData = response['user'];
        state = User(
          id: userData['id'] ?? userData['_id'] ?? 'unknown',
          name: userData['name'] ?? name,
          email: userData['email'] ?? email,
          role: userData['role'] ?? 'client',
        );
        print('✅ AuthProvider: Inscription réussie');
      } else {
        throw Exception('Réponse invalide du serveur');
      }
    } catch (e) {
      print('❌ AuthProvider: Erreur d\'inscription: $e');
      rethrow;
    }
  }

  void logout() {
    state = null;
    print('🚪 AuthProvider: Déconnexion');
  }

  // Méthode pour tester la connexion au serveur
  Future<bool> testServerConnection() async {
    try {
      return await _authService.testConnection();
    } catch (e) {
      print('❌ AuthProvider: Erreur de test de connexion: $e');
      return false;
    }
  }
} 