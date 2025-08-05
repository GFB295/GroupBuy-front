import 'package:flutter/material.dart';
import '../widgets/protected_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;
  final _storage = const FlutterSecureStorage();

  void _logout() async {
    await _storage.delete(key: 'jwt_token');
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _navigateToScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/admin-users');
        break;
      case 2:
        Navigator.pushNamed(context, '/admin-employees');
        break;
      case 3:
        Navigator.pushNamed(context, '/admin-group-products');
        break;
      case 4:
        Navigator.pushNamed(context, '/admin-stats');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProtectedScreen(
      requiredRole: 'admin',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard Admin'),
          backgroundColor: Colors.red[700],
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistiques principales
              const Text(
                'Statistiques Globales',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard('Utilisateurs', '1,234', Icons.people, Colors.blue),
                  _buildStatCard('Produits', '567', Icons.shopping_bag, Colors.green),
                  _buildStatCard('Commandes', '890', Icons.shopping_cart, Colors.orange),
                  _buildStatCard('Employés', '45', Icons.badge, Colors.purple),
                ],
              ),
              const SizedBox(height: 24),
              
              // Accès rapide
              const Text(
                'Accès Rapide',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildQuickAccessCard('Gestion Utilisateurs', Icons.people, Colors.blue, () => Navigator.pushNamed(context, '/admin-users')),
                  _buildQuickAccessCard('Gestion Employés', Icons.badge, Colors.purple, () => Navigator.pushNamed(context, '/admin-employees')),
                  _buildQuickAccessCard('Produits Groupés', Icons.shopping_bag, Colors.green, () => Navigator.pushNamed(context, '/admin-group-products')),
                  _buildQuickAccessCard('Statistiques', Icons.bar_chart, Colors.orange, () => Navigator.pushNamed(context, '/admin-stats')),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _navigateToScreen,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.red[700],
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Utilisateurs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.badge),
              label: 'Employés',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Produits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
