import 'package:flutter/material.dart';
import '../widgets/protected_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
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
        Navigator.pushNamed(context, '/manager-products');
        break;
      case 2:
        Navigator.pushNamed(context, '/manager-orders');
        break;
      case 3:
        Navigator.pushNamed(context, '/manager-stats');
        break;
      case 4:
        Navigator.pushNamed(context, '/manager-profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProtectedScreen(
      requiredRole: 'manager',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard Gérant'),
          backgroundColor: Colors.green[700],
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
              // Statistiques personnalisées
              const Text(
                'Mes Statistiques',
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
                  _buildStatCard('Mes Produits', '23', Icons.shopping_bag, Colors.green),
                  _buildStatCard('Commandes', '156', Icons.shopping_cart, Colors.blue),
                  _buildStatCard('Ventes', '45.2k', Icons.attach_money, Colors.orange),
                  _buildStatCard('Stock Faible', '3', Icons.warning, Colors.red),
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
                  _buildQuickAccessCard('Mes Produits', Icons.shopping_bag, Colors.green, () => Navigator.pushNamed(context, '/manager-products')),
                  _buildQuickAccessCard('Suivi Commandes', Icons.local_shipping, Colors.blue, () => Navigator.pushNamed(context, '/manager-orders')),
                  _buildQuickAccessCard('Statistiques', Icons.bar_chart, Colors.orange, () => Navigator.pushNamed(context, '/manager-stats')),
                  _buildQuickAccessCard('Mon Profil', Icons.person, Colors.purple, () => Navigator.pushNamed(context, '/manager-profile')),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _navigateToScreen,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green[700],
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Produits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping),
              label: 'Commandes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
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
