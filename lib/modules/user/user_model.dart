class User {
  const User({
    this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
  });

  final String? id;
  final String name;
  final String email;
  final bool isAdmin;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      isAdmin: json['isAdmin'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
    };
  }
}
