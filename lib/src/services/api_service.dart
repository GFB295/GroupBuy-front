import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class ApiService {
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

  final _storage = const FlutterSecureStorage();

  // Méthode pour tester la connexion
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
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

      return response;
    } catch (e) {
      print('Erreur de requête HTTP: $e');
      throw Exception('Erreur de connexion au serveur: $e');
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
    final response = await _makeRequest('GET', '/tracking/order/$orderId');
    
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
} 