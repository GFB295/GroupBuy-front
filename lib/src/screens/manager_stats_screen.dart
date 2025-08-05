import 'package:flutter/material.dart';

class ManagerStatsScreen extends StatelessWidget {
  const ManagerStatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques & Ventes'),
      ),
      body: Center(
        child: Text(
          'Statistiques et ventes (à implémenter)',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}