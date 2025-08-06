import 'package:flutter/material.dart';

class SimpleImageTestScreen extends StatelessWidget {
  const SimpleImageTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Simple des Images'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test Simple des Images',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Test 1: Image simple
            _buildImageTest('Test 1: BouillonElectro.jpg', 'assets/images/BouillonElectro.jpg'),
            const SizedBox(height: 20),
            
            // Test 2: Image avec chemin complet
            _buildImageTest('Test 2: Chemin complet', 'lib/src/assets/images/BouillonElectro.jpg'),
            const SizedBox(height: 20),
            
            // Test 3: Image qui existe
            _buildImageTest('Test 3: logo.png', 'assets/images/logo.png'),
            const SizedBox(height: 20),
            
            // Test 4: Image de produit
            _buildImageTest('Test 4: Sac Louis Vuitton', 'assets/images/Sac Louis Vuitton.jpg'),
            const SizedBox(height: 20),
            
            // Test 5: Image avec caractères spéciaux
            _buildImageTest('Test 5: AirPods Max', 'assets/images/AirPorts Max🎧.jpg'),
            const SizedBox(height: 20),
            
            // Test 6: Image qui n'existe pas
            _buildImageTest('Test 6: Image inexistante', 'assets/images/inexistante.jpg'),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTest(String title, String imagePath) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Chemin: $imagePath', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('❌ Erreur image $imagePath: $error');
                    return Container(
                      color: Colors.red[50],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 50),
                          const SizedBox(height: 8),
                          Text(
                            'Erreur de chargement',
                            style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            error.toString(),
                            style: const TextStyle(fontSize: 10, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 