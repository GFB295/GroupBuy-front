import 'package:flutter/material.dart';

class ImageTestWidget extends StatelessWidget {
  const ImageTestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test des Images'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test des images disponibles:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            _buildImageTest('BouillonElectro.jpg', 'assets/images/BouillonElectro.jpg'),
            _buildImageTest('tablette portatif.jpg', 'assets/images/tablette portatif.jpg'),
            _buildImageTest('Sac en wax.jpg', 'assets/images/Sac en wax.jpg'),
            _buildImageTest('Microphone.jpg', 'assets/images/Microphone.jpg'),
            _buildImageTest('Chaussure Adidas.jpg', 'assets/images/Chaussure Adidas.jpg'),
            _buildImageTest('SAMSUNG Galaxy Buds Pro 3 R630.jpg', 'assets/images/SAMSUNG Galaxy Buds Pro 3 R630.jpg'),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTest(String title, String imagePath) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.red[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.red[600], size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'Erreur: $error',
                            style: TextStyle(color: Colors.red[600], fontSize: 12),
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