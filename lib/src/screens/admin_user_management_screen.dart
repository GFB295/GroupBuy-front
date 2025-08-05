import 'package:flutter/material.dart';
import '../widgets/protected_screen.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({Key? key}) : super(key: key);

  @override
  State<AdminUserManagementScreen> createState() => _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Jean Dupont',
      'email': 'jean.dupont@email.com',
      'role': 'user',
      'status': 'active',
      'joinDate': '2024-01-15',
    },
    {
      'id': '2',
      'name': 'Marie Martin',
      'email': 'marie.martin@email.com',
      'role': 'manager',
      'status': 'active',
      'joinDate': '2024-02-20',
    },
    {
      'id': '3',
      'name': 'Pierre Durand',
      'email': 'pierre.durand@email.com',
      'role': 'user',
      'status': 'blocked',
      'joinDate': '2024-03-10',
    },
    {
      'id': '4',
      'name': 'Sophie Bernard',
      'email': 'sophie.bernard@email.com',
      'role': 'user',
      'status': 'active',
      'joinDate': '2024-01-05',
    },
  ];

  List<Map<String, dynamic>> get _filteredUsers {
    if (_searchController.text.isEmpty) {
      return _users;
    }
    return _users.where((user) =>
        user['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
        user['email'].toLowerCase().contains(_searchController.text.toLowerCase())
    ).toList();
  }

  void _addUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un utilisateur'),
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

  void _editUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier ${user['name']}'),
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

  void _toggleUserStatus(Map<String, dynamic> user) {
    setState(() {
      user['status'] = user['status'] == 'active' ? 'blocked' : 'active';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user['name']} ${user['status'] == 'active' ? 'activé' : 'bloqué'}'),
        backgroundColor: user['status'] == 'active' ? Colors.green : Colors.red,
      ),
    );
  }

  void _deleteUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${user['name']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _users.removeWhere((u) => u['id'] == user['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user['name']} supprimé'),
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

  @override
  Widget build(BuildContext context) {
    return ProtectedScreen(
      requiredRole: 'admin',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestion des utilisateurs'),
          backgroundColor: Colors.red[700],
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
                  hintText: 'Rechercher un utilisateur...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
            
            // Liste des utilisateurs
            Expanded(
              child: ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getRoleColor(user['role']),
                        child: Text(
                          user['name'][0].toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        user['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user['email']),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getRoleColor(user['role']),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user['role'],
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: user['status'] == 'active' ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user['status'],
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
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
                            value: 'toggle',
                            child: Row(
                              children: [
                                Icon(
                                  user['status'] == 'active' ? Icons.block : Icons.check_circle,
                                  color: user['status'] == 'active' ? Colors.red : Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(user['status'] == 'active' ? 'Bloquer' : 'Activer'),
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
                              _editUser(user);
                              break;
                            case 'toggle':
                              _toggleUserStatus(user);
                              break;
                            case 'delete':
                              _deleteUser(user);
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
          onPressed: _addUser,
          backgroundColor: Colors.red[700],
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
          tooltip: 'Ajouter un utilisateur',
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'manager':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}