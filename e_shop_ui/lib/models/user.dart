class User {
  final int id;
  final String username;
  final String email;
  final String address;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      address: json['address'] ?? '',
    );
  }

  toJson() {}
}