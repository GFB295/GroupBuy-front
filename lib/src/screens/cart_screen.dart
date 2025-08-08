import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/group_info.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  // Exemple de données (à remplacer par provider ou backend)
  GroupInfo group = GroupInfo(
    name: 'Groupe High-Tech',
    participants: 8,
    maxParticipants: 10,
    discountPercent: 25,
  );

  void updateQuantity(String id, int newQuantity) {
    ref.read(cartProvider.notifier).updateQuantity(id, newQuantity);
  }

  void removeItem(String id) {
    ref.read(cartProvider.notifier).removeFromCart(id);
  }

  double get subtotal => ref.watch(cartProvider).fold(0, (sum, item) => sum + item.price * item.quantity);
  double get oldTotal => ref.watch(cartProvider).fold(0, (sum, item) => sum + (item.oldPrice ?? item.price) * item.quantity);
  double get discount => oldTotal - subtotal;
  double get total => subtotal;

  void validateCart() {
    // Navigation vers la page de paiement
    Navigator.pushNamed(context, '/payment');
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final media = MediaQuery.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // AppBar custom
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade400, Colors.red.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.shade100,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mon Panier',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${cartItems.length} articles',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Card info groupe
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade300, Colors.red.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade100.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.groups, color: Colors.white, size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${group.participants}/${group.maxParticipants} participants',
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-${group.discountPercent}% économisé',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Liste des produits
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Votre panier est vide',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ajoutez des produits pour commencer',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return CartItemWidget(
                          item: item,
                          onQuantityChanged: (q) => updateQuantity(item.id, q),
                          onRemove: () => removeItem(item.id),
                        );
                      },
                    ),
            ),
            
            // Résumé financier (seulement si le panier n'est pas vide)
            if (cartItems.isNotEmpty) ...[
              PriceSummary(
                subtotal: subtotal,
                discount: discount,
                total: total,
              ),
              
              // Bouton valider
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                      elevation: MaterialStateProperty.all(4),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: validateCart,
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade400, Colors.red.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Valider la commande',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// --- CartItemWidget ---
class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;
  const CartItemWidget({Key? key, required this.item, required this.onQuantityChanged, required this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          // Image produit
          ClipRRect(
                borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Infos produit
          Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                      Text(
                  item.variant,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                      '${item.price.toStringAsFixed(2)} €',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                          fontSize: 16,
                      ),
                    ),
                    if (item.oldPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${item.oldPrice!.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                    ],
                  ),
                ],
              ),
            ),
          // Contrôles quantité
          QuantitySelector(
            quantity: item.quantity,
            onChanged: onQuantityChanged,
          ),
          // Supprimer
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

// --- QuantitySelector ---
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  const QuantitySelector({Key? key, required this.quantity, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
          onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$quantity',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Colors.red),
          onPressed: () => onChanged(quantity + 1),
        ),
      ],
    );
  }
}

// --- PriceSummary ---
class PriceSummary extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double total;
  const PriceSummary({Key? key, required this.subtotal, required this.discount, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sous-total', style: TextStyle(fontSize: 15)),
              Text('${subtotal.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Réduction', style: TextStyle(fontSize: 15, color: Colors.teal)),
              Text('-${discount.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal)),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('${total.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
            ],
          ),
        ],
      ),
    );
  }
}