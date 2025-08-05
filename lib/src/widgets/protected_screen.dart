import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class ProtectedScreen extends StatefulWidget {
  final String requiredRole;
  final Widget child;
  const ProtectedScreen({Key? key, required this.requiredRole, required this.child}) : super(key: key);

  @override
  State<ProtectedScreen> createState() => _ProtectedScreenState();
}

class _ProtectedScreenState extends State<ProtectedScreen> {
  final _storage = const FlutterSecureStorage();
  bool _authorized = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      print('🔍 ProtectedScreen - Token trouvé: ${token != null}');
      
      if (token == null) {
        print('❌ ProtectedScreen - Pas de token, redirection vers login');
        _redirectToLogin();
        return;
      }

      // Décoder le JWT pour obtenir le rôle
      try {
        final parts = token.split('.');
        if (parts.length != 3) {
          print('❌ ProtectedScreen - Token invalide (format)');
          throw Exception('Token invalide');
        }
        
        // Normaliser et décoder le payload
        String normalized = base64Url.normalize(parts[1]);
        final payload = utf8.decode(base64Url.decode(normalized));
        final payloadMap = json.decode(payload);
        
        print('🔍 ProtectedScreen - Payload décodé: $payloadMap');
        
        final role = payloadMap['role'] ?? 'client';
        print('🔍 ProtectedScreen - Rôle détecté: $role, Rôle requis: ${widget.requiredRole}');
        
        if (role == widget.requiredRole) {
          print('✅ ProtectedScreen - Accès autorisé');
          setState(() {
            _authorized = true;
            _loading = false;
          });
        } else {
          print('❌ ProtectedScreen - Rôle insuffisant: $role != ${widget.requiredRole}');
          _redirectToLogin();
        }
      } catch (e) {
        print('❌ ProtectedScreen - Erreur décodage JWT: $e');
        _redirectToLogin();
      }
    } catch (e) {
      print('❌ ProtectedScreen - Erreur générale: $e');
      _redirectToLogin();
    }
  }

  void _redirectToLogin() {
    print('🔄 ProtectedScreen - Redirection vers login');
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Vérification des permissions...'),
            ],
          ),
        ),
      );
    }
    
    if (!_authorized) {
      return const SizedBox.shrink();
    }
    
    return widget.child;
  }
}