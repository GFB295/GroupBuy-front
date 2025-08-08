import 'package:flutter/material.dart';

class IconCategorySelector extends StatefulWidget {
  final List<String> categories;
  final Function(String) onCategoryChanged;
  final double height;

  const IconCategorySelector({
    Key? key,
    required this.categories,
    required this.onCategoryChanged,
    this.height = 120,
  }) : super(key: key);

  @override
  State<IconCategorySelector> createState() => _IconCategorySelectorState();
}

class _IconCategorySelectorState extends State<IconCategorySelector> {
  String selectedCategory = 'Tous';

  // Mapping des catégories vers leurs icônes et couleurs
  final Map<String, Map<String, dynamic>> categoryIcons = {
    'Tous': {
      'icon': Icons.all_inclusive,
      'color': Colors.blue,
    },
    'Électronique': {
      'icon': Icons.devices,
      'color': Colors.green,
    },
    'Informatique': {
      'icon': Icons.computer,
      'color': Colors.orange,
    },
    'Mode': {
      'icon': Icons.style,
      'color': Colors.purple,
    },
    'Audio': {
      'icon': Icons.headphones,
      'color': Colors.red,
    },
    'Sport': {
      'icon': Icons.sports_soccer,
      'color': Colors.green,
    },
    'Maison': {
      'icon': Icons.home,
      'color': Colors.brown,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(vertical: 12), // Réduit de 16 à 12
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔧 CORRECTION: Force la Column à prendre le minimum d'espace
        children: [
          // Barre de catégories
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.categories.length,
              itemBuilder: (context, index) {
                final category = widget.categories[index];
                final isSelected = selectedCategory == category;
                final iconData = categoryIcons[category]?['icon'] ?? Icons.category;
                final color = categoryIcons[category]?['color'] ?? Colors.grey;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12, // Taille réduite pour économiser l'espace
                      ),
                    ),
                    avatar: Icon(
                      iconData,
                      color: isSelected ? Colors.white : color,
                      size: 18, // Réduit de 20 à 18
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                      widget.onCategoryChanged(category);
                    },
                    backgroundColor: Colors.grey[100],
                    selectedColor: color,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? color : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: isSelected ? 4 : 1,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8), // Réduit de 16 à 8

          // Affichage de la catégorie sélectionnée - VERSION CORRIGÉE
          Container(
            height: 45, // 🔧 CORRECTION: Hauteur fixe au lieu d'Expanded pour éviter l'overflow
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: categoryIcons[selectedCategory]?['color']?.withOpacity(0.1) ?? Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: categoryIcons[selectedCategory]?['color']?.withOpacity(0.3) ?? Colors.grey[200]!,
              ),
            ),
            child: Row( // 🔧 CORRECTION: Row au lieu de Column pour plus de compacité
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  categoryIcons[selectedCategory]?['icon'] ?? Icons.category,
                  size: 22, // Taille optimisée
                  color: categoryIcons[selectedCategory]?['color'] ?? Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  'Catégorie: $selectedCategory',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: categoryIcons[selectedCategory]?['color'] ?? Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}