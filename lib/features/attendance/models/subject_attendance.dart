import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:markme_student/features/attendance/models/session.dart';

class SubjectAttendance {
  final String subjectId;
  final String subjectName;
  final String subjectType; // ✅ NEW: theory or practical
  final List<Session> sessions;
  final int totalSessions;
  final int presentCount;

  SubjectAttendance({
    required this.subjectId,
    required this.subjectName,
    required this.subjectType,
    required this.sessions,
    required this.totalSessions,
    required this.presentCount,
  });

  SubjectAttendance copyWith({
    String? subjectId,
    String? subjectName,
    String? subjectType,
    List<Session>? sessions,
    int? totalSessions,
    int? presentCount,
  }) {
    return SubjectAttendance(
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      subjectType: subjectType ?? this.subjectType,
      sessions: sessions ?? this.sessions,
      totalSessions: totalSessions ?? this.totalSessions,
      presentCount: presentCount ?? this.presentCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
      'subjectType': subjectType,
      'sessions': sessions.map((x) => x.toMap()).toList(),
      'totalSessions': totalSessions,
      'presentCount': presentCount,
    };
  }

  factory SubjectAttendance.fromMap(Map<String, dynamic> map) {
    return SubjectAttendance(
      subjectId: (map['subjectId'] ?? "") as String,
      subjectName: (map['subjectName'] ?? "") as String,
      subjectType: (map['subjectType'] ?? "theory") as String, // default: theory
      sessions: (map['sessions'] as List<dynamic>? ?? [])
          .map((x) => Session.fromMap(x as Map<String, dynamic>))
          .toList(),
      totalSessions: (map['totalSessions'] ?? 0) as int,
      presentCount: (map['presentCount'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectAttendance.fromJson(String source) =>
      SubjectAttendance.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubjectAttendance(subjectId: $subjectId, subjectName: $subjectName, subjectType: $subjectType, sessions: $sessions, totalSessions: $totalSessions, presentCount: $presentCount)';
  }

  @override
  bool operator ==(covariant SubjectAttendance other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.subjectId == subjectId &&
        other.subjectName == subjectName &&
        other.subjectType == subjectType &&
        listEquals(other.sessions, sessions) &&
        other.totalSessions == totalSessions &&
        other.presentCount == presentCount;
  }

  @override
  int get hashCode {
    return subjectId.hashCode ^
    subjectName.hashCode ^
    subjectType.hashCode ^
    sessions.hashCode ^
    totalSessions.hashCode ^
    presentCount.hashCode;
  }
}
