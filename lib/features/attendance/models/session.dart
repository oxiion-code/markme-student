// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Session {
  final int srNo;
  final DateTime dateAndTime;
  final String isPresent;

  const Session({
    required this.srNo,
    required this.dateAndTime,
    required this.isPresent,
  });

  Session copyWith({
    int? srNo,
    DateTime? dateAndTime,
    String? isPresent,
  }) {
    return Session(
      srNo: srNo ?? this.srNo,
      dateAndTime: dateAndTime ?? this.dateAndTime,
      isPresent: isPresent ?? this.isPresent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'srNo': srNo,
      'dateAndTime': dateAndTime.toIso8601String(),
      'isPresent': isPresent,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      srNo: (map['srNo'] as int?) ?? 0,
      dateAndTime: DateTime.tryParse(map['dateAndTime'] ?? "") ?? DateTime.now(),
      isPresent: (map['isPresent'] ?? "absent") as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Session(srNo: $srNo, dateAndTime: $dateAndTime, isPresent: $isPresent)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Session &&
        other.srNo == srNo &&
        other.dateAndTime == dateAndTime &&
        other.isPresent == isPresent;
  }

  @override
  int get hashCode => srNo.hashCode ^ dateAndTime.hashCode ^ isPresent.hashCode;
}
