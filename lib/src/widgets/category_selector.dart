import 'package:flutter/material.dart';
import 'category_image_display.dart';

class CategorySelector extends StatefulWidget {
  final Function(String)? onCategoryChanged;
  final List<String> categories;
  final Map<String, String> categoryImages;
  final String initialCategory;
  final bool showImage;
  final double imageHeight;

  const CategorySelector({
    Key? key,
    this.onCategoryChanged,
    required this.categories,
    required this.categoryImages,
    this.initialCategory = 'Tous',
    this.showImage = true,
    this.imageHeight = 200,
  }) : super(key: key);

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    
    // Appeler le callback si fourni
    widget.onCategoryChanged?.call(category);
    
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
    return Column(
      children: [
        // Barre de catégories
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.categories.map((category) => _buildCategoryChip(category)).toList(),
            ),
          ),
        ),
        
        // Affichage de l'image (optionnel)
        if (widget.showImage) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CategoryImageDisplay(
              selectedCategory: selectedCategory,
              categoryImages: widget.categoryImages,
              imageHeight: widget.imageHeight,
            ),
          ),
        ],
      ],
    );
  }
}