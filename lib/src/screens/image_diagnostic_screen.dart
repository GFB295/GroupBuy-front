import 'package:flutter/material.dart';
import '../widgets/robust_image_widget.dart';

class ImageDiagnosticScreen extends StatelessWidget {
  const ImageDiagnosticScreen({Key? key}) : super(key: key);

  // Liste de toutes les images disponibles
  static const List<String> availableImages = [
    'assets/images/Equipment Podcast Mixer.jpg',
    'assets/images/Microphone.jpg',
    'assets/images/Microphone Cravate Sans Fil.jpg',
    'assets/images/SAMSUNG Galaxy Buds Pro 3 R630.jpg',
    'assets/images/Chaussure Adidas.jpg',
    'assets/images/Chaussure Vans.jpg',
    'assets/images/Sac en wax.jpg',
    'assets/images/Mini sac African.jpg',
    'assets/images/African TotBag.jpg',
    'assets/images/Crossbody Bag.jpg',
    'assets/images/Sac boîte mini.jpg',
    'assets/images/Petit Sac À Main En Cuir.jpg',
    'assets/images/Sac Louis Vuitton.jpg',
    'assets/images/sac zara.jpg',
    'assets/images/Micro Streaming.jpg',
    'assets/images/Souris de Jeu.jpg',
    'assets/images/Imprimante jet d\'encre.jpg',
    'assets/images/Carte mèreCarte mère.jpg',
    'assets/images/Malette Gameur.jpg',
    'assets/images/Lenovo USB Portable Chargeur.jpg',
    'assets/images/Souris Gamer sans Fil.jpg',
    'assets/images/tablette portatif.jpg',
    'assets/images/Clavier Sans Fil.jpg',
    'assets/images/Ortizan Haut-parleurs Bluetooth portable.jpg',
    'assets/images/AirPorts Max🎧.jpg',
    'assets/images/Haut-parleurs Bluetooth.jpg',
    'assets/images/Mini ventilateur.jpg',
    'assets/images/BouillonElectro.jpg',
    'assets/images/product_placeholder.png',
    'assets/images/logo.png',
  ];

  // Images par catégorie
  static const Map<String, List<String>> imagesByCategory = {
    'Électronique': [
      'assets/images/BouillonElectro.jpg',
      'assets/images/Mini ventilateur.jpg',
    ],
    'Audio': [
      'assets/images/Equipment Podcast Mixer.jpg',
      'assets/images/Microphone.jpg',
      'assets/images/Microphone Cravate Sans Fil.jpg',
      'assets/images/SAMSUNG Galaxy Buds Pro 3 R630.jpg',
      'assets/images/AirPorts Max🎧.jpg',
      'assets/images/Haut-parleurs Bluetooth.jpg',
      'assets/images/Ortizan Haut-parleurs Bluetooth portable.jpg',
    ],
    'Informatique': [
      'assets/images/Souris de Jeu.jpg',
      'assets/images/Imprimante jet d\'encre.jpg',
      'assets/images/Carte mèreCarte mère.jpg',
      'assets/images/Malette Gameur.jpg',
      'assets/images/Lenovo USB Portable Chargeur.jpg',
      'assets/images/Souris Gamer sans Fil.jpg',
      'assets/images/tablette portatif.jpg',
      'assets/images/Clavier Sans Fil.jpg',
      'assets/images/Micro Streaming.jpg',
    ],
    'Mode': [
      'assets/images/Chaussure Adidas.jpg',
      'assets/images/Chaussure Vans.jpg',
      'assets/images/Sac en wax.jpg',
      'assets/images/Mini sac African.jpg',
      'assets/images/African TotBag.jpg',
      'assets/images/Crossbody Bag.jpg',
      'assets/images/Sac boîte mini.jpg',
      'assets/images/Petit Sac À Main En Cuir.jpg',
      'assets/images/Sac Louis Vuitton.jpg',
      'assets/images/sac zara.jpg',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostic des Images'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Forcer le rafraîchissement
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informations générales
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Diagnostic des Images',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Total des images: ${availableImages.length}'),
                    Text('Catégories disponibles: ${imagesByCategory.keys.length}'),
                    const SizedBox(height: 8),
                    const Text(
                      'Ce diagnostic teste toutes les images disponibles et affiche les erreurs de chargement.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Test par catégorie
            ...imagesByCategory.entries.map((entry) => _buildCategorySection(entry.key, entry.value)),
            
            const SizedBox(height: 20),
            
            // Test de toutes les images
            const Text(
              '🔍 Test de toutes les images',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: availableImages.length,
              itemBuilder: (context, index) {
                return ImageDebugWidget(
                  imagePath: availableImages[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category, List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📁 $category (${images.length} images)',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RobustImageWidget(
                        imagePath: images[index],
                        borderRadius: BorderRadius.circular(8),
                        showDebugInfo: true,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      images[index].split('/').last,
                      style: const TextStyle(fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
} 