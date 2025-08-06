import 'package:flutter/material.dart';

class ImageTestWidget extends StatelessWidget {
  const ImageTestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test des Images'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test des Images - Diagnostic',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Test 1: Image simple
            _buildImageTest(
              'Test 1: Image simple (BouillonElectro.jpg)',
              'lib/src/assets/images/BouillonElectro.jpg',
            ),
            
            const SizedBox(height: 20),
            
            // Test 2: Image avec AssetImage
            _buildImageTest(
              'Test 2: AssetImage (BouillonElectro.jpg)',
              'lib/src/assets/images/BouillonElectro.jpg',
              useAssetImage: true,
            ),
            
            const SizedBox(height: 20),
            
            // Test 3: Image qui existe
            _buildImageTest(
              'Test 3: Image qui existe (logo.png)',
              'lib/src/assets/images/logo.png',
            ),
            
            const SizedBox(height: 20),
            
            // Test 4: Image avec chemin relatif
            _buildImageTest(
              'Test 4: Chemin relatif (BouillonElectro.jpg)',
              'assets/images/BouillonElectro.jpg',
            ),
            
            const SizedBox(height: 20),
            
            // Test 5: Image avec chemin absolu
            _buildImageTest(
              'Test 5: Chemin absolu (BouillonElectro.jpg)',
              '/lib/src/assets/images/BouillonElectro.jpg',
            ),
            
            const SizedBox(height: 20),
            
            // Test 6: Image de placeholder
            _buildImageTest(
              'Test 6: Placeholder (product_placeholder.png)',
              'lib/src/assets/images/product_placeholder.png',
            ),
            
            const SizedBox(height: 20),
            
            // Test 7: Image avec AssetImage et placeholder
            _buildImageTest(
              'Test 7: AssetImage avec placeholder (BouillonElectro.jpg)',
              'lib/src/assets/images/BouillonElectro.jpg',
              useAssetImage: true,
              showPlaceholder: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTest(String title, String imagePath, {
    bool useAssetImage = false,
    bool showPlaceholder = false,
  }) {
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
                child: useAssetImage
                    ? Image(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('❌ Erreur image $imagePath: $error');
                          return _buildErrorWidget(error.toString());
                        },

                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('❌ Erreur image $imagePath: $error');
                          return _buildErrorWidget(error.toString());
                        },
                      ),
              ),
            ),
            if (showPlaceholder) ...[
              const SizedBox(height: 10),
              const Text('Placeholder si erreur:', style: TextStyle(fontSize: 12)),
              Container(
                height: 100,
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
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
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
            error,
            style: const TextStyle(fontSize: 10, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 