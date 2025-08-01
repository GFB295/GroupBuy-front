import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AuthService {
  // Configuration de l'URL de base selon la plateforme
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api/users'; // Pour le web
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api/users'; // Pour l'émulateur Android
    } else if (Platform.isIOS) {
      return 'http://localhost:5000/api/users'; // Pour iOS
    } else {
      return 'http://localhost:5000/api/users'; // Par défaut
    }
  }

  // Méthode générique pour les requêtes d'authentification
  Future<http.Response> _makeAuthRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    try {
      http.Response response;
      
      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        default:
          throw Exception('Méthode HTTP non supportée: $method');
      }

      return response;
    } catch (e) {
      print('Erreur de requête d\'authentification: $e');
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _makeAuthRequest(
        'POST',
        '/login',
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erreur de connexion');
      }
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> register(String name, String email, String password) async {
    try {
      final response = await _makeAuthRequest(
        'POST',
        '/register',
        body: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erreur d\'inscription');
      }
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      rethrow;
    }
  }

  // Méthode pour tester la connexion au serveur
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl.replaceAll('/users', '')}/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      print('Erreur de connexion: $e');
      return false;
    }
  }
} 