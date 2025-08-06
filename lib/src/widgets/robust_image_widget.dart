import 'package:flutter/material.dart';

class RobustImageWidget extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? altText;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showDebugInfo;

  const RobustImageWidget({
    Key? key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.altText,
    this.placeholder,
    this.errorWidget,
    this.showDebugInfo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: borderRadius != null
          ? BoxDecoration(
              borderRadius: borderRadius,
            )
          : null,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    // Vérifier si le chemin est valide
    if (imagePath.isEmpty) {
      return _buildErrorWidget('Chemin d\'image vide');
    }

    // Essayer de charger l'image depuis les assets
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        print('❌ Erreur de chargement image: $imagePath');
        print('❌ Erreur: $error');
        return _buildErrorWidget('Erreur de chargement: ${error.toString()}');
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    if (errorWidget != null) return errorWidget!;

    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 40,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          if (showDebugInfo) ...[
            Text(
              'Erreur: $errorMessage',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Chemin: $imagePath',
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            Text(
              altText ?? 'Image non disponible',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// Widget spécialisé pour les images de produits
class ProductImageWidget extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool showDebugInfo;

  const ProductImageWidget({
    Key? key,
    required this.imagePath,
    this.width,
    this.height,
    this.borderRadius,
    this.showDebugInfo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RobustImageWidget(
      imagePath: imagePath,
      width: width,
      height: height,
      borderRadius: borderRadius,
      showDebugInfo: showDebugInfo,
      placeholder: Container(
        width: width,
        height: height,
        color: Colors.grey[100],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 30,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 4),
            Text(
              'Produit',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pour tester les images
class ImageDebugWidget extends StatelessWidget {
  final String imagePath;

  const ImageDebugWidget({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test: $imagePath',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RobustImageWidget(
              imagePath: imagePath,
              width: 200,
              height: 150,
              showDebugInfo: true,
            ),
          ],
        ),
      ),
    );
  }
} 