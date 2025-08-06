import 'package:flutter/material.dart';

class CategoryImageDisplay extends StatefulWidget {
  final String selectedCategory;
  final Map<String, String> categoryImages;
  final double imageHeight;
  final double imageWidth;
  final BoxFit fit;

  const CategoryImageDisplay({
    Key? key,
    required this.selectedCategory,
    required this.categoryImages,
    this.imageHeight = 200,
    this.imageWidth = double.infinity,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  State<CategoryImageDisplay> createState() => _CategoryImageDisplayState();
}

class _CategoryImageDisplayState extends State<CategoryImageDisplay> {
  @override
  Widget build(BuildContext context) {
    // Obtenir l'image pour la catégorie sélectionnée
    final imagePath = widget.categoryImages[widget.selectedCategory];
    
    if (imagePath == null) {
      // Image par défaut si la catégorie n'a pas d'image
      return Container(
        height: widget.imageHeight,
        width: widget.imageWidth,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
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
              'Aucune image pour ${widget.selectedCategory}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: widget.imageHeight,
      width: widget.imageWidth,
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
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: widget.imageHeight,
              width: widget.imageWidth,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 48,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Image non trouvée',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}