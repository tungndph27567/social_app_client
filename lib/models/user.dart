class User {
  late String id;
  late String email;
  late String name;
  late String avatar;
  User(
      {required this.id,
      required this.email,
      required this.avatar,
      required this.name});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}
