import 'dart:convert';

import 'package:flutter/foundation.dart';

class EventModel {
  final String? id;
  final String title;
  final String authorId;
  final List<String> memberIds;
  final DateTime creationDate;
  final String about;
  final String image;
  final List<String>? images;
  final double rating;
  final DateTime startDateTime;
  final DateTime endDateTime;
  EventModel({
    this.id,
    required this.title,
    required this.authorId,
    required this.memberIds,
    required this.creationDate,
    required this.about,
    required this.image,
    this.images,
    required this.rating,
    required this.startDateTime,
    required this.endDateTime,
  });
 

  EventModel copyWith({
    String? id,
    String? title,
    String? authorId,
    List<String>? memberIds,
    DateTime? creationDate,
    String? about,
    String? image,
    List<String>? images,
    double? rating,
    DateTime? startDateTime,
    DateTime? endDateTime,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      memberIds: memberIds ?? this.memberIds,
      creationDate: creationDate ?? this.creationDate,
      about: about ?? this.about,
      image: image ?? this.image,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authorId': authorId,
      'memberIds': memberIds,
      'creationDate': creationDate.millisecondsSinceEpoch,
      'about': about,
      'image': image,
      'images': images,
      'rating': rating,
      'startDateTime': startDateTime.millisecondsSinceEpoch,
      'endDateTime': endDateTime.millisecondsSinceEpoch,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['_id'],
      title: map['title'] ?? '',
      authorId: map['authorId'] ?? '',
      memberIds: List<String>.from(map['memberIds']),
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
      about: map['about'] ?? '',
      image: map['image'] ?? '',
      images: List<String>.from(map['images']),
      rating: map['rating']?.toDouble() ?? 0.0,
      startDateTime: DateTime.fromMillisecondsSinceEpoch(map['startDateTime']),
      endDateTime: DateTime.fromMillisecondsSinceEpoch(map['endDateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, authorId: $authorId, memberIds: $memberIds, creationDate: $creationDate, about: $about, image: $image, images: $images, rating: $rating, startDateTime: $startDateTime, endDateTime: $endDateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is EventModel &&
      other.id == id &&
      other.title == title &&
      other.authorId == authorId &&
      listEquals(other.memberIds, memberIds) &&
      other.creationDate == creationDate &&
      other.about == about &&
      other.image == image &&
      listEquals(other.images, images) &&
      other.rating == rating &&
      other.startDateTime == startDateTime &&
      other.endDateTime == endDateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      authorId.hashCode ^
      memberIds.hashCode ^
      creationDate.hashCode ^
      about.hashCode ^
      image.hashCode ^
      images.hashCode ^
      rating.hashCode ^
      startDateTime.hashCode ^
      endDateTime.hashCode;
  }
}
