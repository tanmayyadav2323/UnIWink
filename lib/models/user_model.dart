import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:buddy_go/models/wink_model.dart';

class User {
  final String id;
  final String phone;
  final String token;
  final String imageUrl;
  final String gender;
  final String des;
  final List<dynamic> winks;

  User({
    required this.id,
    required this.phone,
    required this.token,
    required this.imageUrl,
    required this.gender,
    required this.des,
    required this.winks,
  });

  User copyWith({
    String? id,
    String? phone,
    String? token,
    String? imageUrl,
    String? gender,
    String? des,
    List<dynamic>? winks,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
      des: des ?? this.des,
      winks: winks ?? this.winks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'token': token,
      'imageUrl': imageUrl,
      'gender': gender,
      'des': des,
      'winks': winks,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      phone: map['phone'] ?? '',
      token: map['token'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      gender: map['gender'] ?? '',
      des: map['des'] ?? '',
      winks: map['winks'] != null ? List<dynamic>.from(map['winks']) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, phone: $phone, token: $token, imageUrl: $imageUrl, gender: $gender, des: $des, winks: $winks)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.phone == phone &&
        other.token == token &&
        other.imageUrl == imageUrl &&
        other.gender == gender &&
        other.des == des &&
        listEquals(other.winks, winks);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        phone.hashCode ^
        token.hashCode ^
        imageUrl.hashCode ^
        gender.hashCode ^
        des.hashCode ^
        winks.hashCode;
  }
}
