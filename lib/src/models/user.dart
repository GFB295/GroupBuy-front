class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.role,
  });
} 