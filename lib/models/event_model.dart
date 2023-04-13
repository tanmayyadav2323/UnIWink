import 'dart:convert';

class EventModel {
  final String? id;
  final String title;
  final String authorId;
  final List<String> memberIds;
  final DateTime creationDate;
  final String about;
  final String image;
  final List<String> memberImageUrls;
  final List<String> savedMembers;
  final String organizer;
  // final String latitude;
  // final String longitude;
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
    // required this.latitude,
    // required this.longitude,
    required this.memberImageUrls,
    required this.savedMembers,
    required this.organizer,
    this.images,
    required this.rating,
    required this.startDateTime,
    required this.endDateTime,
  });





  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authorId': authorId,
      'memberIds': memberIds,
      'creationDate': creationDate.millisecondsSinceEpoch,
      'about': about,
      'image': image,
      'memberImageUrls': memberImageUrls,
      'savedMembers': savedMembers,
      'organizer': organizer,
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
      creationDate: DateTime.parse(map['creationDate']),
      about: map['about'] ?? '',
      image: map['image'] ?? '',
      memberImageUrls: List<String>.from(map['memberImageUrls']),
      savedMembers: List<String>.from(map['savedMembers']),
      organizer: map['organizer'] ?? '',
      images: List<String>.from(map['images']),
      rating: map['rating']?.toDouble() ?? 0.0,
      startDateTime: DateTime.parse(map['startDateTime']),
      endDateTime: DateTime.parse(map['endDateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source));

  EventModel copyWith({
    String? id,
    String? title,
    String? authorId,
    List<String>? memberIds,
    DateTime? creationDate,
    String? about,
    String? image,
    List<String>? memberImageUrls,
    List<String>? savedMembers,
    String? organizer,
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
      memberImageUrls: memberImageUrls ?? this.memberImageUrls,
      savedMembers: savedMembers ?? this.savedMembers,
      organizer: organizer ?? this.organizer,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
    );
  }
}
