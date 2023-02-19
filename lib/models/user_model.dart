import 'dart:convert';

class User {
  final String id;
  final String phone;

  User({
    required this.id,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
