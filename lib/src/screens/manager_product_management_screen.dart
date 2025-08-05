import 'package:flutter/material.dart';
import '../widgets/protected_screen.dart';

class ManagerProductManagementScreen extends StatefulWidget {
  const ManagerProductManagementScreen({Key? key}) : super(key: key);

  @override
  State<ManagerProductManagementScreen> createState() => _ManagerProductManagementScreenState();
}

class _ManagerProductManagementScreenState extends State<ManagerProductManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Smartphone Samsung Galaxy',
      'price': 299.99,
      'stock': 15,
      'status': 'active',
      'category': 'Électronique',
      'image': 'https://via.placeholder.com/100',
    },
    {
      'id': '2',
      'name': 'Casque Audio Bluetooth',
      'price': 89.99,
      'stock': 8,
      'status': 'active',
      'category': 'Audio',
      'image': 'https://via.placeholder.com/100',
    },
    {
      'id': '3',
      'name': 'Montre Connectée',
      'price': 199.99,
      'stock': 3,
      'status': 'low_stock',
      'category': 'Électronique',
      'image': 'https://via.placeholder.com/100',
    },
    {
      'id': '4',
      'name': 'Sac à Dos Laptop',
      'price': 49.99,
      'stock': 0,
      'status': 'out_of_stock',
      'category': 'Mode',
      'image': 'https://via.placeholder.com/100',
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    if (_searchController.text.isEmpty) {
      return _products;
    }
    return _products.where((product) =>
        product['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
        product['category'].toLowerCase().contains(_searchController.text.toLowerCase())
    ).toList();
  }

  void _addProduct() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un produit'),
        content: const Text('Fonctionnalité à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _editProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier ${product['name']}'),
        content: const Text('Fonctionnalité à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${product['name']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _products.removeWhere((p) => p['id'] == product['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product['name']} supprimé'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'low_stock':
        return Colors.orange;
      case 'out_of_stock':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'En stock';
      case 'low_stock':
        return 'Stock faible';
      case 'out_of_stock':
        return 'Rupture';
      default:
        return 'Inconnu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProtectedScreen(
      requiredRole: 'manager',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestion de mes produits'),
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // Barre de recherche
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Rechercher un produit...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
            
            // Liste des produits
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      title: Text(
                        product['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${product['price']} €'),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  product['category'],
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(product['status']),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getStatusText(product['status']),
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Text('Stock: ${product['stock']} unités'),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: const Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Modifier'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: const Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Supprimer'),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              _editProduct(product);
                              break;
                            case 'delete':
                              _deleteProduct(product);
                              break;
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addProduct,
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
          tooltip: 'Ajouter un produit',
        ),
      ),
    );
  }
}