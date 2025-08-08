import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AuthService {
  // Configuration de l'URL de base selon la plateforme
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api'; // Pour le web
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api'; // Pour l'émulateur Android
    } else if (Platform.isIOS) {
      return 'http://localhost:5000/api'; // Pour iOS
    } else {
      return 'http://localhost:5000/api'; // Par défaut
    }
  }

  // Méthode générique pour les requêtes d'authentification
  Future<http.Response> _makeAuthRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    print('🔐 Auth Request: $method $uri');
    if (body != null) print('📄 Auth Body: $body');
    
    try {
      http.Response response;
      
      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body != null ? jsonEncode(body) : null,
          ).timeout(const Duration(seconds: 10));
          break;
        default:
          throw Exception('Méthode HTTP non supportée: $method');
      }

      print('📡 Auth Response - Status: ${response.statusCode}');
      print('📡 Auth Response - Body: ${response.body}');

      return response;
    } catch (e) {
      print('❌ Erreur de requête d\'authentification: $e');
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password, ) async {
    try {
      print('🔐 Tentative de connexion pour: $email');
      
      final response = await _makeAuthRequest(
        'POST',
        '/users/login',
        body: {'email': email, 'password': password,},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Connexion réussie pour: $email');
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        print('❌ Échec de connexion: ${errorData['error']}');
        throw Exception(errorData['error'] ?? 'Erreur de connexion');
      }
    } catch (e) {
      print('❌ Erreur lors de la connexion: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> register(String name, String email, String password, String address, String contact) async {
    try {
      print('📝 Tentative d\'inscription pour: $email');
      
      final response = await _makeAuthRequest(
        'POST',
        '/users/register',
        body: {'name': name, 'email': email, 'password': password, 'contact' : contact, 'address' : address, },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ Inscription réussie pour: $email');
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        print('❌ Échec d\'inscription: ${errorData['error']}');
        throw Exception(errorData['error'] ?? 'Erreur d\'inscription');
      }
    } catch (e) {
      print('❌ Erreur lors de l\'inscription: $e');
      rethrow;
    }
  }

  // Méthode pour tester la connexion au serveur
  Future<bool> testConnection() async {
    try {
      print('🔍 Test de connexion au serveur...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      print('🔍 Test de connexion - Status: ${response.statusCode}');
      print('🔍 Test de connexion - Body: ${response.body}');
      
      final isConnected = response.statusCode == 200;
      print(isConnected ? '✅ Serveur accessible' : '❌ Serveur inaccessible');
      
      return isConnected;
    } catch (e) {
      print('❌ Erreur de connexion: $e');
      return false;
    }
  }
} 