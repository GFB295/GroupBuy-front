import 'package:flutter/material.dart';

class ManagerOrderTrackingScreen extends StatelessWidget {
  const ManagerOrderTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi des commandes'),
      ),
      body: Center(
        child: Text(
          'Liste des commandes (à implémenter)',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}