import 'dart:convert';

class User {
  final String id;
  final String phone;
  final String token;
  final String imageUrl;

  User({
    required this.id,
    required this.token,
    required this.phone,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'token': token,
      'imageUrl': imageUrl
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      phone: map['phone'] ?? '',
      token: map['token'] ?? '',
      imageUrl: map['imageUrl']??'',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
