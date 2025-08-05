import 'package:flutter/material.dart';

class SimpleCategorySelector extends StatefulWidget {
  final Function(String)? onCategoryChanged;
  final String? selectedCategory;

  const SimpleCategorySelector({
    Key? key,
    this.onCategoryChanged,
    this.selectedCategory,
  }) : super(key: key);

  @override
  State<SimpleCategorySelector> createState() => _SimpleCategorySelectorState();
}

class _SimpleCategorySelectorState extends State<SimpleCategorySelector> {
  late String selectedCategory;
  
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

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory ?? 'Tous';
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

  Widget _buildCategoryImage() {
    final imagePath = categoryImages[selectedCategory];
    
    if (imagePath == null) {
      return _buildIconPlaceholder();
    }

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Erreur de chargement image: $imagePath - $error');
            return _buildIconPlaceholder();
          },
        ),
      ),
    );
  }

  Widget _buildIconPlaceholder() {
    IconData iconData;
    Color iconColor;
    
    switch (selectedCategory) {
      case 'Tous':
        iconData = Icons.all_inclusive;
        iconColor = Colors.blue;
        break;
      case 'Électronique':
        iconData = Icons.devices;
        iconColor = Colors.green;
        break;
      case 'Informatique':
        iconData = Icons.computer;
        iconColor = Colors.orange;
        break;
      case 'Mode':
        iconData = Icons.style;
        iconColor = Colors.purple;
        break;
      case 'Audio':
        iconData = Icons.headphones;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.category;
        iconColor = Colors.grey;
    }

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 64,
            color: iconColor,
          ),
          const SizedBox(height: 16),
          Text(
            selectedCategory,
            style: TextStyle(
              color: iconColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Catégorie sélectionnée',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage(String message) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[400]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 48,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Catégorie: $selectedCategory',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
              children: categories.map((category) => _buildCategoryChip(category)).toList(),
            ),
          ),
        ),
        
        // Affichage de l'image de catégorie
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildCategoryImage(),
        ),
      ],
    );
  }
} 