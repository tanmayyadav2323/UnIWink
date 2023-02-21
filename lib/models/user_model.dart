import 'dart:convert';

class User {
  final String id;
  final String phone;
  final String token;
  final String imageUrl;
  final String gender;
  User({
    required this.id,
    required this.phone,
    required this.token,
    required this.imageUrl,
    required this.gender,
  });



  User copyWith({
    String? id,
    String? phone,
    String? token,
    String? imageUrl,
    String? gender,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'phone': phone,
      'token': token,
      'imageUrl': imageUrl,
      'gender': gender,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      phone: map['phone'] ?? '',
      token: map['token'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      gender: map['gender'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
