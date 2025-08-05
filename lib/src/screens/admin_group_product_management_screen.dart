import 'package:flutter/material.dart';

class AdminGroupProductManagementScreen extends StatelessWidget {
  const AdminGroupProductManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des produits groupés'),
      ),
      body: Center(
        child: Text(
          'Liste des produits groupés (à implémenter)',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Ajouter un produit groupé
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un produit groupé',
      ),
    );
  }
}