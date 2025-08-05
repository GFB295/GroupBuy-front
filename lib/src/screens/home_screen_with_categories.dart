import 'package:flutter/material.dart';
import '../widgets/category_selector.dart';

class HomeScreenWithCategories extends StatefulWidget {
  const HomeScreenWithCategories({Key? key}) : super(key: key);

  @override
  State<HomeScreenWithCategories> createState() => _HomeScreenWithCategoriesState();
}

class _HomeScreenWithCategoriesState extends State<HomeScreenWithCategories> {
  String currentCategory = 'Tous';
  
  // Map des catégories vers leurs images
  final Map<String, String> categoryImages = {
    'Tous': 'assets/images/BouillonElectro.jpg',
    'Électronique': 'assets/images/BouillonElectro.jpg',
    'Informatique': 'assets/images/tablette portatif.jpg',
    'Mode': 'assets/images/Sac en wax.jpg',
    'Audio': 'assets/images/Microphone.jpg',
  };

  // Liste des catégories
  final List<String> categories = [
    'Tous',
    'Électronique',
    'Informatique',
    'Mode',
    'Audio',
  ];

  void _onCategoryChanged(String category) {
    setState(() {
      currentCategory = category;
    });
    
    // Ici tu peux ajouter ta logique pour filtrer les produits
    // par exemple : _filterProductsByCategory(category);
    
    print('Catégorie changée vers: $category');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achat Groupé'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Section de recherche
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher une offre...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // Logique de filtres
                  },
                  icon: const Icon(Icons.filter_list),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Sélecteur de catégories avec images
          CategorySelector(
            categories: categories,
            categoryImages: categoryImages,
            onCategoryChanged: _onCategoryChanged,
            imageHeight: 180,
          ),
          
          // Contenu principal (produits filtrés)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Produits - $currentCategory',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Zone pour afficher les produits filtrés
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Produits de la catégorie "$currentCategory"',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ici tu peux afficher tes produits filtrés',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
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