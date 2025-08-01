import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../utils/palette.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? selectedCategory;
  String sortBy = 'createdAt';
  String order = 'desc';
  double? minPrice;
  double? maxPrice;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Achat Groupé',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppPalette.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Section de filtres
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Barre de recherche et filtres
                Row(
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
                      onPressed: _showFilterDialog,
                      icon: const Icon(Icons.filter_list),
                      style: IconButton.styleFrom(
                        backgroundColor: AppPalette.accent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Catégories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('Tous', null),
                      _buildCategoryChip('Électronique', 'Électronique'),
                      _buildCategoryChip('Informatique', 'Informatique'),
                      _buildCategoryChip('Mode', 'Mode'),
                      _buildCategoryChip('Audio', 'Audio'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Liste des offres
          Expanded(
            child: productsAsync.when(
              data: (products) => products.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: () => ref.read(productProvider.notifier).refreshOffers(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _buildProductCard(product);
                        },
                      ),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Navigation vers les autres écrans
          switch (index) {
            case 0:
              // Déjà sur l'accueil
              break;
            case 1:
              Navigator.pushNamed(context, '/cart');
              break;
            case 2:
              Navigator.pushNamed(context, '/orders');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildCategoryChip(String label, String? category) {
    final isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedCategory = selected ? category : null;
          });
          _loadFilteredOffers();
        },
        backgroundColor: Colors.grey[200],
        selectedColor: AppPalette.accent,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          '/product-detail',
          arguments: product,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                                     // Nom, catégorie et favori
                   Row(
                     children: [
                       Expanded(
                         child: Text(
                           product.name,
                           style: GoogleFonts.poppins(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                         decoration: BoxDecoration(
                           color: AppPalette.accent.withOpacity(0.1),
                           borderRadius: BorderRadius.circular(12),
                         ),
                         child: Text(
                           product.category,
                           style: TextStyle(
                             color: AppPalette.accent,
                             fontSize: 12,
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                       ),
                       const SizedBox(width: 8),
                       Consumer(
                         builder: (context, ref, child) {
                           final isFavorite = ref.watch(favoritesProvider.notifier).isInFavorites(product.id);
                           return IconButton(
                             onPressed: () {
                               if (isFavorite) {
                                 ref.read(favoritesProvider.notifier).removeFromFavorites(product.id);
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   const SnackBar(
                                     content: Text('Retiré des favoris'),
                                     backgroundColor: Colors.orange,
                                   ),
                                 );
                               } else {
                                 ref.read(favoritesProvider.notifier).addToFavorites(product);
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   const SnackBar(
                                     content: Text('Ajouté aux favoris'),
                                     backgroundColor: Colors.green,
                                   ),
                                 );
                               }
                             },
                             icon: Icon(
                               isFavorite ? Icons.favorite : Icons.favorite_border,
                               color: isFavorite ? Colors.red : Colors.grey,
                               size: 20,
                             ),
                             padding: EdgeInsets.zero,
                             constraints: const BoxConstraints(),
                           );
                         },
                       ),
                     ],
                   ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    product.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Prix
                  Row(
                    children: [
                      Text(
                        '${product.groupPrice.toStringAsFixed(0)} FCFA',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.accent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${product.individualPrice.toStringAsFixed(0)} FCFA',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '-${product.savingsPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progrès du groupe
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: product.currentParticipants / product.requiredParticipants,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(AppPalette.accent),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${product.currentParticipants}/${product.requiredParticipants}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.people, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${product.remainingParticipants} places restantes',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          if (!product.isExpired)
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 16, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTimeRemaining(product.timeRemaining),
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                                     // Boutons d'action
                   Row(
                     children: [
                       // Bouton Ajouter au panier
                       Expanded(
                         child: OutlinedButton.icon(
                           onPressed: () {
                             ref.read(cartProvider.notifier).addToCart(product);
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: Text('${product.name} ajouté au panier'),
                                 backgroundColor: Colors.green,
                                 duration: const Duration(seconds: 2),
                               ),
                             );
                           },
                                                       icon: const Icon(Icons.add_shopping_cart, size: 18),
                           label: const Text('Panier'),
                           style: OutlinedButton.styleFrom(
                             foregroundColor: AppPalette.accent,
                             side: BorderSide(color: AppPalette.accent),
                             padding: const EdgeInsets.symmetric(vertical: 12),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(12),
                             ),
                           ),
                         ),
                       ),
                       const SizedBox(width: 12),
                       // Bouton Rejoindre le groupe
                       Expanded(
                         child: ElevatedButton(
                           onPressed: product.isExpired || product.isGroupComplete
                               ? null
                               : () => Navigator.pushNamed(
                                     context,
                                     '/join-group',
                                     arguments: product,
                                   ),
                           style: ElevatedButton.styleFrom(
                             backgroundColor: AppPalette.accent,
                             foregroundColor: Colors.white,
                             padding: const EdgeInsets.symmetric(vertical: 12),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(12),
                             ),
                           ),
                           child: Text(
                             product.isExpired
                                 ? 'Expiré'
                                 : product.isGroupComplete
                                     ? 'Complet'
                                     : 'Rejoindre',
                             style: const TextStyle(fontWeight: FontWeight.bold),
                           ),
                         ),
                       ),
                     ],
                   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucune offre disponible',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Revenez plus tard pour découvrir de nouvelles offres',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(productProvider.notifier).refreshOffers(),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtres'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tri
            DropdownButtonFormField<String>(
              value: sortBy,
              decoration: const InputDecoration(labelText: 'Trier par'),
              items: const [
                DropdownMenuItem(value: 'createdAt', child: Text('Date de création')),
                DropdownMenuItem(value: 'groupPrice', child: Text('Prix')),
                DropdownMenuItem(value: 'endDate', child: Text('Date de fin')),
              ],
              onChanged: (value) => setState(() => sortBy = value!),
            ),
            const SizedBox(height: 16),
            // Ordre
            DropdownButtonFormField<String>(
              value: order,
              decoration: const InputDecoration(labelText: 'Ordre'),
              items: const [
                DropdownMenuItem(value: 'desc', child: Text('Décroissant')),
                DropdownMenuItem(value: 'asc', child: Text('Croissant')),
              ],
              onChanged: (value) => setState(() => order = value!),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadFilteredOffers();
            },
            child: const Text('Appliquer'),
          ),
        ],
      ),
    );
  }

  void _loadFilteredOffers() {
    ref.read(productProvider.notifier).loadOffers(
      category: selectedCategory,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sortBy: sortBy,
      order: order,
    );
  }

  String _formatTimeRemaining(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}j ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}min';
    } else {
      return '${duration.inMinutes}min';
    }
  }
}

