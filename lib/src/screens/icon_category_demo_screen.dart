import 'package:flutter/material.dart';
import '../utils/palette.dart';

class IconCategorySelector extends StatefulWidget {
  final List<String> categories;
  final Function(String?) onCategoryChanged;
  final String? initialCategory;

  const IconCategorySelector({
    Key? key,
    required this.categories,
    required this.onCategoryChanged,
    this.initialCategory,
  }) : super(key: key);

  @override
  State<IconCategorySelector> createState() => _IconCategorySelectorState();
}

class _IconCategorySelectorState extends State<IconCategorySelector> {
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barre de catégories
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              final category = widget.categories[index];
              final isSelected = selectedCategory == category;
              
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = isSelected ? null : category;
                    });
                    widget.onCategoryChanged(selectedCategory);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppPalette.accent : Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: AppPalette.accent.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getCategoryIcon(category),
                          color: isSelected ? Colors.white : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Zone d'affichage de l'icône sélectionnée
        if (selectedCategory != null) ...[
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppPalette.accent.withOpacity(0.1),
                  AppPalette.accent.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppPalette.accent.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppPalette.accent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getCategoryIcon(selectedCategory!),
                    size: 48,
                    color: AppPalette.accent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Catégorie sélectionnée : $selectedCategory',
                  style: TextStyle(
                    color: AppPalette.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'Sélectionnez une catégorie',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'tous':
        return Icons.all_inclusive;
      case 'électronique':
        return Icons.devices;
      case 'informatique':
        return Icons.computer;
      case 'mode':
        return Icons.style;
      case 'audio':
        return Icons.headphones;
      case 'sport':
        return Icons.sports_soccer;
      case 'maison':
        return Icons.home;
      case 'livres':
        return Icons.book;
      case 'jeux':
        return Icons.games;
      case 'beauté':
        return Icons.face;
      default:
        return Icons.category;
    }
  }
}