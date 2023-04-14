import 'dart:convert';

enum WinkStatus {
  accepted,
  winked,
  unwinked,
  none
}

class WinkModel {
  final String? id;
  final String winkedById;
  final String winkedToId;
  final WinkStatus status;
  final String message;

  WinkModel({
    this.id,
    required this.winkedById,
    required this.winkedToId,
    required this.status,
    required this.message,
  });

  static WinkModel empty() {
    return WinkModel(
        winkedById: '',
        winkedToId: '',
        status: WinkStatus.none,
        message: '');
  }

  WinkModel copyWith({
    String? id,
    String? winkedById,
    String? winkedToId,
    String? message,
    WinkStatus? status,
  }) {
    return WinkModel(
        id: id ?? this.id,
        winkedById: winkedById ?? this.winkedById,
        winkedToId: winkedToId ?? this.winkedToId,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'winkedById': winkedById,
      'winkedToId': winkedToId,
      'status': status.index,
      'message': message
    };
  }

  factory WinkModel.fromMap(Map<String, dynamic> map) {
    return WinkModel(
      id: map['_id'],
      winkedById: map['winkedById'],
      winkedToId: map['winkedToId'],
      status: WinkStatus.values[map['status']],
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
}
