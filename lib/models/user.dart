class User {
  final String username;
  final String password;
  final String? name;
  final String? role;
  final String? image;

  User({
    required this.username,
    required this.password,
    this.name,
    this.role,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      name: json['name'],
      role: json['role'],
      image: json['image'],
    );
  }
}
