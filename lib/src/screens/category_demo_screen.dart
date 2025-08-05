import 'package:flutter/material.dart';
import '../widgets/category_image_display.dart';

class CategoryDemoScreen extends StatefulWidget {
  const CategoryDemoScreen({Key? key}) : super(key: key);

  @override
  State<CategoryDemoScreen> createState() => _CategoryDemoScreenState();
}

class _CategoryDemoScreenState extends State<CategoryDemoScreen> {
  String selectedCategory = 'Tous';
  
  // Map des catégories vers leurs images
  final Map<String, String> categoryImages = {
    'Tous': 'assets/images/BouillonElectro.jpg',
    'Électronique': 'assets/images/BouillonElectro.jpg',
    'Informatique': 'assets/images/tablette portatif.jpg',
    'Mode': 'assets/images/Sac en wax.jpg',
    'Audio': 'assets/images/Microphone.jpg',
  };

  // Liste des catégories disponibles
  final List<String> categories = [
    'Tous',
    'Électronique',
    'Informatique',
    'Mode',
    'Audio',
  ];

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    print('Catégorie sélectionnée: $category');
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = selectedCategory == category;
    
    return GestureDetector(
      onTap: () => _selectCategory(category),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: isSelected 
            ? Border.all(color: Colors.blue, width: 2)
            : null,
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Démonstration Catégories'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Barre de catégories
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catégories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) => _buildCategoryChip(category)).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Affichage de l'image de catégorie
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Image pour: $selectedCategory',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                CategoryImageDisplay(
                  selectedCategory: selectedCategory,
                  categoryImages: categoryImages,
                  imageHeight: 250,
                ),
              ],
            ),
          ),
          
          // Informations supplémentaires
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Catégorie sélectionnée: $selectedCategory',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Image: ${categoryImages[selectedCategory] ?? 'Aucune image'}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nombre de catégories: ${categories.length}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 