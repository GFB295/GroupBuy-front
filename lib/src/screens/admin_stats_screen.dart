import 'package:flutter/material.dart';

class AdminStatsScreen extends StatelessWidget {
  const AdminStatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques & Rapports'),
      ),
      body: Center(
        child: Text(
          'Statistiques et rapports (à implémenter)',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}