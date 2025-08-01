import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class OrderService {
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

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final token = await _storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('$baseUrl/orders/user'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['orders'] as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erreur lors du chargement des commandes');
    }
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    final token = await _storage.read(key: 'jwt_token');
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(orderData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors de la création de la commande');
    }
  }

  Future<Map<String, dynamic>> getOrderTracking(String orderId) async {
    final token = await _storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('$baseUrl/tracking/order/$orderId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors du chargement du suivi');
    }
  }
} 