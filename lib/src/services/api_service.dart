import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Adresse IP locale à modifier si besoin
  static const String localIp = '127.0.0.1'; // ou ton IP réseau si tu veux tester sur mobile
  static const int backendPort = 5000;

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://$localIp:$backendPort/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:$backendPort/api';
    } else if (Platform.isIOS) {
      return 'http://localhost:$backendPort/api';
    } else {
      return 'http://localhost:$backendPort/api';
    }
  }

  final _storage = const FlutterSecureStorage();

  // Méthode pour tester la connexion
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      print('Test de connexion - Status:  [32m${response.statusCode} [0m');
      print('Test de connexion - Body: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Erreur de connexion: $e');
      return false;
    }
  }

  // Méthode générique pour les requêtes HTTP
  Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final token = await _storage.read(key: 'jwt_token');
    
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final uri = Uri.parse('$baseUrl$endpoint');
    
    print('🌐 Requête HTTP: $method $uri');
    print('📦 Headers: $defaultHeaders');
    if (body != null) print('📄 Body: $body');
    
    try {
      http.Response response;
      
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: defaultHeaders);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: defaultHeaders);
          break;
        default:
          throw Exception('Méthode HTTP non supportée: $method');
      }

      print('📡 Réponse - Status: ${response.statusCode}');
      print('📡 Réponse - Body: ${response.body}');

      return response;
    } catch (e) {
      print('❌ Erreur de requête HTTP: $e');
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  // Authentification
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      print('🔐 Login - Status: ${response.statusCode}');
      print('🔐 Login - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Sauvegarder le token
        if (data['token'] != null) {
          await _storage.write(key: 'jwt_token', value: data['token']);
        }
        
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Erreur de connexion');
      }
    } catch (e) {
      print('❌ Erreur de login: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Inscription
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📝 Register - Status: ${response.statusCode}');
      print('📝 Register - Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // Sauvegarder le token
        if (data['token'] != null) {
          await _storage.write(key: 'jwt_token', value: data['token']);
        }
        
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Erreur d\'inscription');
      }
    } catch (e) {
      print('❌ Erreur de register: $e');
      throw Exception('Erreur d\'inscription: $e');
    }
  }

  // Récupérer les offres actives
  Future<List<Map<String, dynamic>>> fetchOffers({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? order,
  }) async {
    final queryParams = <String, String>{};
    if (category != null) queryParams['category'] = category;
    if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
    if (sortBy != null) queryParams['sortBy'] = sortBy;
    if (order != null) queryParams['order'] = order;

    final queryString = queryParams.isNotEmpty 
        ? '?${Uri(queryParameters: queryParams).query}' 
        : '';

    final response = await _makeRequest('GET', '/products/offers$queryString');
    
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erreur lors du chargement des offres: ${response.statusCode}');
    }
  }

  // Récupérer une offre par ID
  Future<Map<String, dynamic>> fetchOfferById(String id) async {
    final response = await _makeRequest('GET', '/products/offers/$id');
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors du chargement de l\'offre: ${response.statusCode}');
    }
  }

  // Récupérer les catégories
  Future<List<String>> fetchCategories() async {
    final response = await _makeRequest('GET', '/products/categories');
    
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Erreur lors du chargement des catégories: ${response.statusCode}');
    }
  }

  // Récupérer les groupes actifs
  Future<List<Map<String, dynamic>>> fetchActiveGroups() async {
    final response = await _makeRequest('GET', '/groups/active');
    
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erreur lors du chargement des groupes: ${response.statusCode}');
    }
  }

  // Rejoindre un groupe
  Future<Map<String, dynamic>> joinGroup(String groupId, String paymentMethod) async {
    final response = await _makeRequest(
      'POST',
      '/groups/$groupId/join',
      body: {'paymentMethod': paymentMethod},
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Erreur lors de la jointure du groupe');
    }
  }

  // Récupérer les commandes de l'utilisateur
  Future<Map<String, dynamic>> fetchUserOrders({
    String? status,
    int limit = 10,
    int page = 1,
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
      'page': page.toString(),
    };
    if (status != null) queryParams['status'] = status;

    final queryString = '?${Uri(queryParameters: queryParams).query}';
    final response = await _makeRequest('GET', '/orders/user$queryString');
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors du chargement des commandes: ${response.statusCode}');
    }
  }

  // Récupérer le suivi d'une commande
  Future<Map<String, dynamic>> fetchOrderTracking(String orderId) async {
    final response = await _makeRequest('GET', '/orders/$orderId/tracking');
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors du chargement du suivi: ${response.statusCode}');
    }
  }

  // Récupérer les notifications
  Future<Map<String, dynamic>> fetchNotifications({
    bool? isRead,
    String? type,
    int limit = 20,
    int page = 1,
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
      'page': page.toString(),
    };
    if (isRead != null) queryParams['isRead'] = isRead.toString();
    if (type != null) queryParams['type'] = type;

    final queryString = '?${Uri(queryParameters: queryParams).query}';
    final response = await _makeRequest('GET', '/notifications/user$queryString');
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors du chargement des notifications: ${response.statusCode}');
    }
  }

  // Marquer une notification comme lue
  Future<void> markNotificationAsRead(String notificationId) async {
    final response = await _makeRequest('PUT', '/notifications/$notificationId/read');
    
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour de la notification: ${response.statusCode}');
    }
  }

  // Traiter un paiement Mobile Money
  Future<Map<String, dynamic>> processMobileMoneyPayment({
    required String groupId,
    required String phoneNumber,
    required double amount,
  }) async {
    final response = await _makeRequest(
      'POST',
      '/payments/mobile-money',
      body: {
        'groupId': groupId,
        'phoneNumber': phoneNumber,
        'amount': amount,
        'paymentMethod': 'mobile_money',
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Erreur lors du paiement');
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null;
  }

  // Méthode pour récupérer le profil utilisateur
  static Future<Map<String, dynamic>?> getProfile(String token) async {
    try {
      print('🔍 getProfile - Début de la requête');
      print('🔍 getProfile - URL: $baseUrl/api/users/profile');
      print('🔍 getProfile - Token: ${token.substring(0, 20)}...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('🔍 getProfile - Status: ${response.statusCode}');
      print('🔍 getProfile - Headers: ${response.headers}');
      print('🔍 getProfile - Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Profil récupéré avec succès');
        print('🔍 Données du profil: $data');
        return data;
      } else if (response.statusCode == 401) {
        print('❌ Token invalide ou expiré');
        return null;
      } else if (response.statusCode == 404) {
        print('❌ Route /api/users/profile non trouvée');
        return null;
      } else {
        print('❌ Erreur lors de la récupération du profil: ${response.statusCode}');
        print('❌ Corps de la réponse: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Exception lors de la récupération du profil: $e');
      return null;
    }
  }

  // Méthode pour récupérer les statistiques utilisateur
  static Future<Map<String, dynamic>?> getUserStats(String token) async {
    try {
      print('🔍 getUserStats - Début de la requête');
      print('🔍 getUserStats - URL: $baseUrl/api/users/stats');
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/stats'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('🔍 getUserStats - Status: ${response.statusCode}');
      print('🔍 getUserStats - Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Statistiques récupérées avec succès');
        print('🔍 Données des stats: $data');
        return data;
      } else if (response.statusCode == 401) {
        print('❌ Token invalide ou expiré');
        return null;
      } else if (response.statusCode == 404) {
        print('❌ Route /api/users/stats non trouvée');
        return null;
      } else {
        print('❌ Erreur lors de la récupération des stats: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Exception lors de la récupération des stats: $e');
      return null;
    }
  }
} 