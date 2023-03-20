import 'dart:convert';

enum WinkStatus {
  accepted,
  winked,
  unwinked,
}

class WinkModel {
  final String? id;
  final String winkedById;
  final String winkedToId;
  final WinkStatus status;

  WinkModel({
    this.id,
    required this.winkedById,
    required this.winkedToId,
    required this.status,
  });

  WinkModel copyWith({
    String? id,
    String? winkedById,
    String? winkedToId,
    WinkStatus? status,
  }) {
    return WinkModel(
      id: id ?? this.id,
      winkedById: winkedById ?? this.winkedById,
      winkedToId: winkedToId ?? this.winkedToId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'winkedById': winkedById,
      'winkedToId': winkedToId,
      'status': status.index,
    };
  }

  factory WinkModel.fromMap(Map<String, dynamic> map) {
    return WinkModel(
      id: map['_id'],
      winkedById: map['winkedById'],
      winkedToId: map['winkedToId'],
      status: WinkStatus.values[map['status']],
    );
  }

  String toJson() => json.encode(toMap());

  factory WinkModel.fromJson(String source) => WinkModel.fromMap(json.decode(source));

  @override
  String toString() => 'WinkModel(id: $id, winkedById: $winkedById, winkedToId: $winkedToId, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WinkModel &&
        other.id == id &&
        other.winkedById == winkedById &&
        other.winkedToId == winkedToId &&
        other.status == status;
  }

  @override
  int get hashCode => id.hashCode ^ winkedById.hashCode ^ winkedToId.hashCode ^ status.hashCode;
}
