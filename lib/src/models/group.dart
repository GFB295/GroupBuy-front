import 'product.dart';
import 'user.dart';

class GroupMember {
  final String userId;
  final DateTime joinedAt;
  final String paymentStatus;
  final String paymentMethod;

  GroupMember({
    required this.userId,
    required this.joinedAt,
    required this.paymentStatus,
    required this.paymentMethod,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      userId: json['userId'] ?? '',
      joinedAt: DateTime.parse(json['joinedAt']),
      paymentStatus: json['paymentStatus'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? 'mobile_money',
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'joinedAt': joinedAt.toIso8601String(),
    'paymentStatus': paymentStatus,
    'paymentMethod': paymentMethod,
  };
}

class Group {
  final String id;
  final String productId;
  final Product? product;
  final String name;
  final String? description;
  final int requiredParticipants;
  final int currentParticipants;
  final List<GroupMember> members;
  final String status;
  final DateTime endDate;
  final double groupPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isComplete => currentParticipants >= requiredParticipants;
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isActive => status == 'active';
  int get remainingParticipants => requiredParticipants - currentParticipants;
  double get completionPercentage => (currentParticipants / requiredParticipants) * 100;

  Group({
    required this.id,
    required this.productId,
    this.product,
    required this.name,
    this.description,
    required this.requiredParticipants,
    required this.currentParticipants,
    required this.members,
    required this.status,
    required this.endDate,
    required this.groupPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json['_id'] ?? json['id'],
    productId: json['productId'] ?? '',
    product: json['productId'] is Map ? Product.fromJson(json['productId']) : null,
    name: json['name'] ?? '',
    description: json['description'],
    requiredParticipants: json['requiredParticipants'] ?? 0,
    currentParticipants: json['currentParticipants'] ?? 0,
    members: (json['members'] as List<dynamic>? ?? []).map((m) => GroupMember.fromJson(m)).toList(),
    status: json['status'] ?? 'active',
    endDate: DateTime.parse(json['endDate']),
    groupPrice: (json['groupPrice'] ?? 0).toDouble(),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'product': product?.toJson(),
    'name': name,
    'description': description,
    'requiredParticipants': requiredParticipants,
    'currentParticipants': currentParticipants,
    'members': members.map((m) => m.toJson()).toList(),
    'status': status,
    'endDate': endDate.toIso8601String(),
    'groupPrice': groupPrice,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  Group copyWith({
    String? id,
    String? productId,
    Product? product,
    String? name,
    String? description,
    int? requiredParticipants,
    int? currentParticipants,
    List<GroupMember>? members,
    String? status,
    DateTime? endDate,
    double? groupPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Group(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      name: name ?? this.name,
      description: description ?? this.description,
      requiredParticipants: requiredParticipants ?? this.requiredParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      members: members ?? this.members,
      status: status ?? this.status,
      endDate: endDate ?? this.endDate,
      groupPrice: groupPrice ?? this.groupPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
