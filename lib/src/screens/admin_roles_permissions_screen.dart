import 'package:flutter/material.dart';

class AdminRolesPermissionsScreen extends StatelessWidget {
  const AdminRolesPermissionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des rôles & permissions'),
      ),
      body: Center(
        child: Text(
          'Liste des rôles et permissions (à implémenter)',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}