class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final double individualPrice;
  final double groupPrice;
  final int requiredParticipants;
  final int currentParticipants;
  final bool isActive;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Propriétés calculées
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isGroupComplete => currentParticipants >= requiredParticipants;
  Duration get timeRemaining => endDate.difference(DateTime.now());
  double get savings => individualPrice - groupPrice;
  double get savingsPercentage => (savings / individualPrice) * 100;
  int get remainingParticipants => requiredParticipants - currentParticipants;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.individualPrice,
    required this.groupPrice,
    required this.requiredParticipants,
    required this.currentParticipants,
    required this.isActive,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      individualPrice: (json['individualPrice'] ?? 0).toDouble(),
      groupPrice: (json['groupPrice'] ?? 0).toDouble(),
      requiredParticipants: json['requiredParticipants'] ?? 0,
      currentParticipants: json['currentParticipants'] ?? 0,
      isActive: json['isActive'] ?? true,
      endDate: DateTime.parse(json['endDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'individualPrice': individualPrice,
      'groupPrice': groupPrice,
      'requiredParticipants': requiredParticipants,
      'currentParticipants': currentParticipants,
      'isActive': isActive,
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? imageUrl,
    double? individualPrice,
    double? groupPrice,
    int? requiredParticipants,
    int? currentParticipants,
    bool? isActive,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      individualPrice: individualPrice ?? this.individualPrice,
      groupPrice: groupPrice ?? this.groupPrice,
      requiredParticipants: requiredParticipants ?? this.requiredParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      isActive: isActive ?? this.isActive,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 