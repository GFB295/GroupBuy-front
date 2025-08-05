import 'package:flutter/material.dart';

class ManagerProfileScreen extends StatelessWidget {
  const ManagerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
      ),
      body: Center(
        child: Text(
          'Gestion du profil (à implémenter)',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}