import 'product.dart';
import 'user.dart';

class GroupPurchase {
  final String id;
  final String title;
  final double price;
  final List<User> participants;
  final Product product;

  GroupPurchase({
    required this.id,
    required this.title,
    required this.price,
    required this.participants,
    required this.product,
  });
} 