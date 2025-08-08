import '../models/group_purchase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/user.dart';

final dummyUsers = [
  User(id: 'u1', name: 'Alice', email: 'Alice@gmail.com', role: 'admin'),
  User(id: 'u2', name: 'Bob', email: 'Bob@gmail.com', role: 'client'),
];

// AJOUT DE LA VARIABLE MANQUANTE dummyProducts
final List<Product> dummyProducts = [
  // Produits Électronique
  Product(
    id: '1',
    name: 'Bouillon Électrique',
    description: 'Bouillon électrique de haute qualité pour une cuisine parfaite',
    category: 'Électronique',
    imageUrl: 'assets/images/BouillonElectro.jpg',
    individualPrice: 89.99,
    groupPrice: 59.99,
    requiredParticipants: 5,
    currentParticipants: 3,
    isActive: true,
    endDate: DateTime.now().add(const Duration(days: 7)),
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now(),
  ),
  
  Product(
    id: '2',
    name: 'Mini Ventilateur',
    description: 'Ventilateur portable pour un rafraîchissement instantané',
    category: 'Électronique',
    imageUrl: 'assets/images/Mini ventilateur.jpg',
    individualPrice: 45.99,
    groupPrice: 29.99,
    requiredParticipants: 3,
    currentParticipants: 1,
    isActive: true,
    endDate: DateTime.now().add(const Duration(days: 5)),
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
  ),
  
  // Produits Audio
  Product(
    id: '3',
    name: 'AirPods Max',
    description: 'Casque audio premium avec qualité sonore exceptionnelle',
    category: 'Audio',
    imageUrl: 'assets/images/AirPorts Max🎧.jpg',
    individualPrice: 549.99,
    groupPrice: 399.99,
    requiredParticipants: 8,
    currentParticipants: 6,
    isActive: true,
    endDate: DateTime.now().add(const Duration(days: 10)),
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    updatedAt: DateTime.now(),
  ),
  
  Product(
    id: '4',
    name: 'Microphone Professionnel',
    description: 'Microphone de qualité studio pour enregistrement',
    category: 'Audio',
    imageUrl: 'assets/images/Microphone.jpg',
    individualPrice: 129.99,
    groupPrice: 89.99,
    requiredParticipants: 4,
    currentParticipants: 2,
    isActive: true,
    endDate: DateTime.now().add(const Duration(days: 6)),
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now(),
  ),
  
  Product(
    id: '5',
    name: 'Haut-parleurs Bluetooth',
    description: 'Haut-parleurs portables avec son puissant',
    category: 'Audio',
    imageUrl: 'assets/images/Haut-parleurs Bluetooth.jpg',
    individualPrice: 79.99,
    groupPrice: 54.99,
    requiredParticipants: 6,
    currentParticipants: 4,
    isActive: true,
    endDate: DateTime.now().add(const Duration(days: 8)),
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
  ),
  
  // Produits Informatique
  Product(
    id: '6',
    name: 'Tablette Portable',
    description: 'Tablette performante pour tous vos besoins',
    category: 'Informatique',
    imageUrl: 'assets/images/tablette portatif.jpg',
    individualPrice: 299.99,
    groupPrice: 199.99,
    requiredParticipants: 10,
    currentParticipants: 7,
    isActive: true,
    endDate: DateTime.now().add(const Duration(days: 12)),
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
    updatedAt: DateTime.now(),
  ),
  
  Product(
    id: '7',
    name: 'Souris de Jeu',
    description: 'Souris gaming avec précision et rapidité',
    category: 'Informatique',
    imageUrl: 'assets/images/Souris de Jeu.jpg',
    individualPrice: 89.99,
    groupPrice: 59.99,
    requiredParticipants: 5,
    currentParticipants: 3,
    isActive: true,
    endDate: DateTime.now().add(const Duration(days: 7)),
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now(),
  ),
  
  Product(
    id: '8',
    name: 'Clavier Sans Fil',
    description: 'Clavier ergonomique sans fil pour plus de liberté',
    category: 'Informatique',
    imageUrl: 'assets/images/Clavier Sans Fil.jpg',
    individualPrice: 69.99,
    groupPrice: 44.99,
    requiredParticipants: 4,
    currentParticipants: 2,
    isActive: true,
    endDate: DateTime.now().add(const Duration(days: 6)),
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
  ),
  
  // Produits Mode
  Product(
    id: '9',
    name: 'Sac Louis Vuitton',
    description: 'Sac de luxe authentique en cuir premium',
    category: 'Mode',
    imageUrl: 'assets/images/Sac Louis Vuitton.jpg',
    individualPrice: 1299.99,
    groupPrice: 899.99,
    requiredParticipants: 15,
    currentParticipants: 12,
    isActive: true,
    endDate: DateTime.now().add(const Duration(days: 15)),
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now(),
  ),
  
  Product(
    id: '10',
    name: 'Chaussure Adidas',
    description: 'Chaussures de sport confortables et stylées',
    category: 'Mode',
    imageUrl: 'assets/images/Chaussure Adidas.jpg',
    individualPrice: 129.99,
    groupPrice: 89.99,
    requiredParticipants: 6,
    currentParticipants: 4,
    isActive: true,
    endDate: DateTime.now().add(const Duration(days: 8)),
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    updatedAt: DateTime.now(),
  ),
  
  Product(
    id: '11',
    name: 'Sac en Wax',
    description: 'Sac traditionnel africain en tissu wax',
    category: 'Mode',
    imageUrl: 'assets/images/Sac en wax.jpg',
    individualPrice: 79.99,
    groupPrice: 54.99,
    requiredParticipants: 4,
    currentParticipants: 2,
    isActive: true,
    endDate: DateTime.now().add(const Duration(days: 6)),
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now(),
  ),
  
  Product(
    id: '12',
    name: 'Chaussure Vans',
    description: 'Chaussures casual tendance et confortables',
    category: 'Mode',
    imageUrl: 'assets/images/Chaussure Vans.jpg',
    individualPrice: 89.99,
    groupPrice: 64.99,
    requiredParticipants: 5,
    currentParticipants: 3,
    isActive: true,
    endDate: DateTime.now().add(const Duration(days: 7)),
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
  ),
];

// Classe DummyData gardée pour compatibilité
class DummyData {
  static List<Product> getProducts() {
    return dummyProducts; // Utilise maintenant la variable globale
  }
}

final dummyOrders = [
  Order(
    id: 'o1',
    userId: 'u1',
    items: [
      OrderItem(
        productId: 'p1',
        productName: 'Smartphone Samsung',
        quantity: 1,
        price: 15.0,
      ),
    ],
    totalAmount: 15.0,
    status: 'pending',
    groupId: 'g1',
    productId: 'p1',
    paymentStatus: 'paid',
    paymentMethod: 'mobile_money',
    deliveryStatus: 'preparing',
    createdAt: DateTime.now(),
  ),
  Order(
    id: 'o2',
    userId: 'u2',
    items: [
      OrderItem(
        productId: 'p2',
        productName: 'Laptop HP',
        quantity: 1,
        price: 30.0,
      ),
    ],
    totalAmount: 30.0,
    status: 'pending',
    groupId: 'g2',
    productId: 'p2',
    paymentStatus: 'paid',
    paymentMethod: 'mobile_money',
    deliveryStatus: 'shipped',
    createdAt: DateTime.now(),
  ),
];

final dummyGroupPurchases = [
  GroupPurchase(
    id: 'g1',
    title: 'Achat groupé 1',
    price: 15.0,
    participants: dummyUsers,
    product: dummyProducts[0],
  ),
  GroupPurchase(
    id: 'g2',
    title: 'Achat groupé 2',
    price: 30.0,
    participants: [dummyUsers[1]],
    product: dummyProducts[1],
  ),
];

final dummyCart = [
  {
    'product': dummyProducts[0],
    'quantity': 1,
  },
  {
    'product': dummyProducts[1],
    'quantity': 2,
  },
];

final dummyOrderData = [
  {
    'title': 'Commande 1',
    'status': 'En cours',
    'price': 15.0,
  },
  {
    'title': 'Commande 2',
    'status': 'Expédiée',
    'price': 30.0,
  },
];