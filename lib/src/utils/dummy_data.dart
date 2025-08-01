import '../models/group_purchase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/user.dart';

final dummyUsers = [
  User(id: 'u1', name: 'Alice', email: 'Alice@gmail.com'),
  User(id: 'u2', name: 'Bob', email: 'Bob@gmail.com'),
];

final dummyProducts = [
  Product(
    id: 'p1',
    name: 'Produit 1',
    description: 'Description du produit 1',
    category: 'Électronique',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/65/No-Image-Placeholder.png',
    individualPrice: 25.0,
    groupPrice: 15.0,
    requiredParticipants: 5,
    currentParticipants: 3,
    isActive: true,
    endDate: DateTime.now().add(Duration(days: 7)),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: 'p2',
    name: 'Produit 2',
    description: 'Description du produit 2',
    category: 'Vêtements',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/65/No-Image-Placeholder.png',
    individualPrice: 40.0,
    groupPrice: 30.0,
    requiredParticipants: 3,
    currentParticipants: 2,
    isActive: true,
    endDate: DateTime.now().add(Duration(days: 5)),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];

final dummyOrders = [
  Order(
    id: 'o1',
    userId: 'u1',
    groupId: 'g1',
    productId: 'p1',
    quantity: 1,
    totalAmount: 15.0,
    paymentStatus: 'paid',
    paymentMethod: 'mobile_money',
    deliveryStatus: 'preparing',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Order(
    id: 'o2',
    userId: 'u2',
    groupId: 'g2',
    productId: 'p2',
    quantity: 1,
    totalAmount: 30.0,
    paymentStatus: 'paid',
    paymentMethod: 'mobile_money',
    deliveryStatus: 'shipped',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
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