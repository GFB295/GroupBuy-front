import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';
import 'dart:convert';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _storage = const FlutterSecureStorage();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      print('🔍 Début du chargement des données utilisateur');
      final token = await _storage.read(key: 'jwt_token');
      print('🔍 Token trouvé: ${token != null}');
      
      // Charger les données locales en premier (toujours disponible)
      await _loadLocalUserData();
      
      // Essayer de récupérer les données depuis l'API en arrière-plan
      if (token != null) {
        _loadApiDataInBackground(token);
      }
    } catch (e) {
      print('❌ Erreur lors du chargement du profil: $e');
      await _loadLocalUserData();
    }
  }

  Future<void> _loadLocalUserData() async {
    try {
      // Récupérer les données de connexion stockées localement
      final userEmail = await _storage.read(key: 'user_email');
      final userName = await _storage.read(key: 'user_name');
      final userContact = await _storage.read(key: 'user_contact');
      final userAddress = await _storage.read(key: 'user_address');
      final userRole = await _storage.read(key: 'user_role');
      
      print('🔍 Données locales trouvées:');
      print('  - Email: $userEmail');
      print('  - Nom: $userName');
      print('  - Contact: $userContact');
      print('  - Adresse: $userAddress');
      print('  - Rôle: $userRole');
      
      // Récupérer ou créer les statistiques locales
      final stats = await _getOrCreateLocalStats(userEmail ?? 'default@email.com');
      
      setState(() {
        userData = {
          'name': userName ?? 'Utilisateur',
          'email': userEmail ?? 'email@example.com',
          'phone': userContact ?? 'Non renseigné',
          'address': userAddress ?? 'Non renseigné',
          'role': userRole ?? 'client',
          'stats': stats,
        };
        isLoading = false;
      });
    } catch (e) {
      print('❌ Erreur lors du chargement des données locales: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _getOrCreateLocalStats(String email) async {
    try {
      // Essayer de récupérer les stats depuis le cache
      final cachedStats = await _storage.read(key: 'user_stats_$email');
      if (cachedStats != null) {
        final stats = Map<String, dynamic>.from(json.decode(cachedStats));
        print('✅ Statistiques récupérées depuis le cache');
        return stats;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération du cache: $e');
    }
    
    // Créer de nouvelles statistiques
    final stats = _calculateLocalStatsFromEmail(email);
    
    // Sauvegarder dans le cache
    try {
      await _storage.write(key: 'user_stats_$email', value: json.encode(stats));
      print('✅ Statistiques sauvegardées dans le cache');
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde du cache: $e');
    }
    
    return stats;
  }

  Map<String, dynamic> _calculateLocalStatsFromEmail(String email) {
    // Statistiques basées sur l'email pour être cohérentes
    final emailHash = email.hashCode;
    
    return {
      'orders': (emailHash % 15) + 1, // 1-15 commandes
      'groups': (emailHash % 8) + 1,  // 1-8 groupes
      'balance': (emailHash % 40000) + 5000, // 5000-45000 FCFA
    };
  }

  // Méthode pour obtenir le nombre d'articles dans le panier
  int _getCartItemCount() {
    try {
      final cartItems = ref.read(cartProvider);
      return cartItems.fold(0, (sum, item) => sum + item.quantity);
    } catch (e) {
      print('❌ Erreur lors du calcul du panier: $e');
      return 0;
    }
  }

  // Méthode pour calculer le prix total du panier
  double _getCartTotalPrice() {
    try {
      final cartItems = ref.read(cartProvider);
      return cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    } catch (e) {
      print('❌ Erreur lors du calcul du prix total: $e');
      return 0.0;
    }
  }

  // Méthode pour obtenir les vraies statistiques basées sur les données réelles
  Map<String, dynamic> _getRealStats() {
    final orders = ref.read(orderProvider);
    final cartItemCount = _getCartItemCount();
    final cartTotalPrice = _getCartTotalPrice();
    
    // Calculer le total dépensé (commandes + panier actuel)
    final totalSpent = orders.fold(0.0, (sum, order) => sum + order.totalAmount) + cartTotalPrice;
    
    return {
      'orders': orders.length, // Nombre réel de commandes
      'cartItems': cartItemCount, // Nombre d'articles dans le panier
      'balance': totalSpent.toInt(), // Total dépensé + panier actuel
    };
  }

  Future<void> _loadApiDataInBackground(String token) async {
    try {
      print('🔍 Tentative de récupération des données API en arrière-plan');
      final response = await ApiService.getProfile(token);
      if (response != null) {
        print('✅ Données API récupérées avec succès');
        setState(() {
          userData = {
            ...userData!,
            ...response,
          };
        });
      }
      
      // Essayer de récupérer les statistiques
      final statsResponse = await ApiService.getUserStats(token);
      if (statsResponse != null) {
        print('✅ Statistiques API récupérées avec succès');
        setState(() {
          userData = {
            ...userData!,
            'stats': statsResponse,
          };
        });
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des données API: $e');
    }
  }

  // Méthode pour créer une commande à partir du panier actuel
  void _createOrderFromCart() {
    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) return;
    
    final totalAmount = cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userData?['email'] ?? 'user@example.com',
      items: cartItems.map((item) => OrderItem(
        productId: item.id,
        productName: item.name,
        quantity: item.quantity,
        price: item.price,
      )).toList(),
      totalAmount: totalAmount,
      status: 'pending',
      createdAt: DateTime.now(),
    );
    
    // Ajouter la commande à l'historique
    ref.read(orderProvider.notifier).addOrder(order);
    
    // Vider le panier
    ref.read(cartProvider.notifier).clearCart();
    
    // Afficher un message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Commande créée avec succès ! Total: ${totalAmount.toStringAsFixed(2)} €'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Forcer la mise à jour de l'interface
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('🔍 Build ProfileScreen - userData: $userData');
    print('🔍 Build ProfileScreen - isLoading: $isLoading');
    
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Si pas de données utilisateur, afficher un message d'erreur
    if (userData == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'Mon Profil',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppPalette.primary,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                _loadUserData();
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Impossible de charger les données',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vérifiez votre connexion et réessayez',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  _loadUserData();
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    // Données par défaut si userData est null
    final displayName = userData?['name'] ?? 'Utilisateur';
    final displayEmail = userData?['email'] ?? 'email@example.com';
    final displayPhone = userData?['phone'] ?? 'Non renseigné';
    final displayAddress = userData?['address'] ?? 'Non renseigné';
    final displayRole = userData?['role'] ?? 'client';
    
    print('🔍 Données d\'affichage:');
    print('  - Nom: $displayName');
    print('  - Email: $displayEmail');
    print('  - Téléphone: $displayPhone');
    print('  - Adresse: $displayAddress');
    print('  - Rôle: $displayRole');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Mon Profil',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppPalette.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _loadUserData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Navigation vers les paramètres
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête du profil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppPalette.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppPalette.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Nom de l'utilisateur
                  Text(
                    displayName,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  Text(
                    displayEmail,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Statistiques
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        _getRealStats()['orders'].toString(),
                        'Commandes'
                      ),
                      _buildStatItem(
                        _getRealStats()['cartItems'].toString(),
                        'Panier'
                      ),
                      _buildStatItem(
                        '${_getRealStats()['balance']}',
                        '€'
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Informations personnelles
                  _buildSection(
                    'Informations personnelles',
                    [
                      _buildInfoTile(
                        Icons.person,
                        'Nom complet',
                        displayName,
                        onTap: () {
                          // Éditer le nom
                        },
                      ),
                      _buildInfoTile(
                        Icons.email,
                        'Email',
                        displayEmail,
                        onTap: () {
                          // Éditer l'email
                        },
                      ),
                      _buildInfoTile(
                        Icons.phone,
                        'Téléphone',
                        displayPhone,
                        onTap: () {
                          // Éditer le téléphone
                        },
                      ),
                      _buildInfoTile(
                        Icons.location_on,
                        'Adresse',
                        displayAddress,
                        onTap: () {
                          // Éditer l'adresse
                        },
                      ),
                      _buildInfoTile(
                        Icons.verified_user,
                        'Rôle',
                        displayRole,
                        onTap: null,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Activité récente
                  _buildSection(
                    'Activité récente',
                    [
                      _buildActivityTile(
                        'Commande #1234',
                        'Commande confirmée',
                        'Il y a 2 heures',
                        Icons.check_circle,
                        Colors.green,
                      ),
                      _buildActivityTile(
                        'Groupe Électronique',
                        'Groupe complété',
                        'Il y a 1 jour',
                        Icons.people,
                        Colors.blue,
                      ),
                      _buildActivityTile(
                        'Livraison en cours',
                        'Livraison en cours',
                        'Il y a 3 jours',
                        Icons.local_shipping,
                        Colors.orange,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Panier actuel
                  if (_getRealStats()['cartItems'] > 0) ...[
                    _buildSection(
                      'Mon Panier',
                      [
                        _buildCartSummary(),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Actions
                  _buildSection(
                    'Actions',
                    [
                      _buildActionTile(
                        Icons.shopping_bag,
                        'Mes commandes',
                        'Voir l\'historique de vos achats',
                        () => Navigator.pushNamed(context, '/orders'),
                      ),
                      _buildActionTile(
                        Icons.notifications,
                        'Notifications',
                        'Gérer vos préférences',
                        () => Navigator.pushNamed(context, '/notifications'),
                      ),
                      _buildActionTile(
                        Icons.favorite,
                        'Favoris',
                        'Produits sauvegardés',
                        () => Navigator.pushNamed(context, '/favorites'),
                      ),
                      _buildActionTile(
                        Icons.help,
                        'Aide & Support',
                        'Centre d\'aide et contact',
                        () {
                          // Navigation vers l'aide
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bouton de déconnexion
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Déconnexion'),
                            content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Annuler'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await _storage.delete(key: 'jwt_token');
                                  if (mounted) {
                                    Navigator.pop(context);
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/login',
                                      (route) => false,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Déconnexion'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Se déconnecter',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value, {VoidCallback? onTap}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppPalette.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppPalette.accent, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: onTap != null
          ? const Icon(Icons.edit, color: Colors.grey, size: 20)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildActivityTile(String title, String subtitle, String time, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[500],
        ),
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppPalette.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppPalette.accent, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildCartSummary() {
    final cartItems = ref.watch(cartProvider);
    final totalItems = cartItems.fold(0, (sum, item) => sum + item.quantity);
    final totalPrice = cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.red.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                'Panier actuel',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$totalItems articles',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${totalPrice.toStringAsFixed(2)} €',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Voir le panier'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _createOrderFromCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Commander'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Panier vidé'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.grey.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Vider'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}