import 'package:flutter/material.dart';

class AdminEmployeeManagementScreen extends StatelessWidget {
  const AdminEmployeeManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des employés'),
      ),
      body: Center(
        child: Text(
          'Liste des employés (à implémenter)',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Ajouter un employé
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un employé',
      ),
    );
  }
}