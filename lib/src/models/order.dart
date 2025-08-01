import 'product.dart';
import 'group.dart';

class DeliveryAddress {
  final String? street;
  final String? city;
  final String? postalCode;
  final String? country;

  DeliveryAddress({
    this.street,
    this.city,
    this.postalCode,
    this.country,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      street: json['street'],
      city: json['city'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'country': country,
    };
  }
}

class Order {
  final String id;
  final String userId;
  final String groupId;
  final String productId;
  final Product? product;
  final Group? group;
  final int quantity;
  final double totalAmount;
  final String paymentStatus;
  final String paymentMethod;
  final String deliveryStatus;
  final DeliveryAddress? deliveryAddress;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;
  final DateTime? actualDelivery;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Propriétés calculées
  bool get isDelivered => deliveryStatus == 'delivered';
  bool get isShipped => deliveryStatus == 'shipped';
  bool get isPreparing => deliveryStatus == 'preparing';
  bool get isPending => deliveryStatus == 'pending';
  bool get isCancelled => deliveryStatus == 'cancelled';
  bool get canBeCancelled => !isShipped && !isDelivered;

  Order({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.productId,
    this.product,
    this.group,
    required this.quantity,
    required this.totalAmount,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.deliveryStatus,
    this.deliveryAddress,
    this.trackingNumber,
    this.estimatedDelivery,
    this.actualDelivery,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? json['id'],
      userId: json['userId'] ?? '',
      groupId: json['groupId'] ?? '',
      productId: json['productId'] ?? '',
      product: json['productId'] != null && json['productId'] is Map 
          ? Product.fromJson(json['productId']) 
          : null,
      group: json['groupId'] != null && json['groupId'] is Map 
          ? Group.fromJson(json['groupId']) 
          : null,
      quantity: json['quantity'] ?? 1,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? 'mobile_money',
      deliveryStatus: json['deliveryStatus'] ?? 'pending',
      deliveryAddress: json['deliveryAddress'] != null 
          ? DeliveryAddress.fromJson(json['deliveryAddress']) 
          : null,
      trackingNumber: json['trackingNumber'],
      estimatedDelivery: json['estimatedDelivery'] != null 
          ? DateTime.parse(json['estimatedDelivery']) 
          : null,
      actualDelivery: json['actualDelivery'] != null 
          ? DateTime.parse(json['actualDelivery']) 
          : null,
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'groupId': groupId,
      'productId': productId,
      'product': product?.toJson(),
      'group': group?.toJson(),
      'quantity': quantity,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'deliveryStatus': deliveryStatus,
      'deliveryAddress': deliveryAddress?.toJson(),
      'trackingNumber': trackingNumber,
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
      'actualDelivery': actualDelivery?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Order copyWith({
    String? id,
    String? userId,
    String? groupId,
    String? productId,
    Product? product,
    Group? group,
    int? quantity,
    double? totalAmount,
    String? paymentStatus,
    String? paymentMethod,
    String? deliveryStatus,
    DeliveryAddress? deliveryAddress,
    String? trackingNumber,
    DateTime? estimatedDelivery,
    DateTime? actualDelivery,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      group: group ?? this.group,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      actualDelivery: actualDelivery ?? this.actualDelivery,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 