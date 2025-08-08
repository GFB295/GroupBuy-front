import 'product.dart';

class CartItem {
  final String id;
  final String name;
  final String variant;
  final String imageUrl;
  final double price;
  final double? oldPrice;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.variant,
    required this.imageUrl,
    required this.price,
    this.oldPrice,
    required this.quantity,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? variant,
    String? imageUrl,
    double? price,
    double? oldPrice,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      variant: variant ?? this.variant,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      quantity: quantity ?? this.quantity,
    );
  }
} 