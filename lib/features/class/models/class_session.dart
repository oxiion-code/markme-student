import 'dart:convert';
import 'package:flutter/foundation.dart';

class ClassSession {
  final String classId;
  final String subjectId;
  final String subjectName;
  final String sectionId;
  final String sectionName;
  final String teacherId;
  final String teacherName;
  final String roomName;
  final int semesterNo;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // "scheduled", "live", "ended", "cancelled"
  final String sessionType; // "theory", "lab", "tutorial", "seminar", "extra"
  final String group; // "all", "grp1", "grp2"
  final String? attendanceId; // nullable
  final List<String> studentIds; // Store student IDs (or roll numbers)
  final bool synced; // false = offline-only, true = already pushed to server

  ClassSession({
    required this.classId,
    required this.subjectId,
    required this.subjectName,
    required this.sectionId,
    required this.sectionName,
    required this.teacherId,
    required this.teacherName,
    required this.roomName,
    required this.semesterNo,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.sessionType,
    required this.group,
    this.attendanceId,
    this.studentIds = const [],
    this.synced = false,
  });

  // 🔹 CopyWith
  ClassSession copyWith({
    String? classId,
    String? subjectId,
    String? subjectName,
    String? sectionId,
    String? sectionName,
    String? teacherId,
    String? teacherName,
    String? roomName,
    int? semesterNo,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    String? sessionType,
    String? group,
    String? attendanceId,
    List<String>? studentIds,
    bool? synced,
  }) {
    return ClassSession(
      classId: classId ?? this.classId,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      roomName: roomName ?? this.roomName,
      semesterNo: semesterNo ?? this.semesterNo,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      sessionType: sessionType ?? this.sessionType,
      group: group ?? this.group,
      attendanceId: attendanceId ?? this.attendanceId,
      studentIds: studentIds ?? this.studentIds,
      synced: synced ?? this.synced,
    );
  }

  // 🔹 Map conversion
  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'sectionId': sectionId,
      'sectionName': sectionName,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'roomName': roomName,
      'semesterNo': semesterNo,
      'date': date.millisecondsSinceEpoch,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'status': status,
      'sessionType': sessionType,
      'group': group,
      'attendanceId': attendanceId,
      'studentIds': studentIds,
      'synced': synced,
    };
  }

  factory ClassSession.fromMap(Map<String, dynamic> map) {
    return ClassSession(
      classId: map['classId'] ?? "",
      subjectId: map['subjectId'] ?? "",
      subjectName: map['subjectName'] ?? "",
      sectionId: map['sectionId'] ?? "",
      sectionName: map['sectionName'] ?? "",
      teacherId: map['teacherId'] ?? "",
      teacherName: map['teacherName'] ?? "",
      roomName: map['roomName'] ?? "",
      semesterNo: map['semesterNo'] ?? 0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] ?? 0),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] ?? 0),
      status: map['status'] ?? "",
      sessionType: map['sessionType'] ?? "",
      group: map['group'] ?? "",
      attendanceId: map['attendanceId'],
      studentIds: List<String>.from(map['studentIds'] ?? []),
      synced: map['synced'] ?? false,
    );
  }

  // 🔹 JSON conversion
  String toJson() => json.encode(toMap());

  factory ClassSession.fromJson(String source) =>
      ClassSession.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassSession(classId: $classId, subjectId: $subjectId, subjectName: $subjectName, sectionId: $sectionId, sectionName: $sectionName, teacherId: $teacherId, teacherName: $teacherName, roomName: $roomName, semesterNo: $semesterNo, date: $date, startTime: $startTime, endTime: $endTime, status: $status, sessionType: $sessionType, group: $group, attendanceId: $attendanceId, students: $studentIds, synced: $synced)';
  }

  // 🔹 Equality check
  @override
  bool operator ==(covariant ClassSession other) {
    if (identical(this, other)) return true;

    return other.classId == classId &&
        other.subjectId == subjectId &&
        other.subjectName == subjectName &&
        other.sectionId == sectionId &&
        other.sectionName == sectionName &&
        other.teacherId == teacherId &&
        other.teacherName == teacherName &&
        other.roomName == roomName &&
        other.semesterNo == semesterNo &&
        other.date == date &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.status == status &&
        other.sessionType == sessionType &&
        other.group == group &&
        other.attendanceId == attendanceId &&
        listEquals(other.studentIds, studentIds) &&
        other.synced == synced;
  }

  @override
  int get hashCode {
    return classId.hashCode ^
    subjectId.hashCode ^
    subjectName.hashCode ^
    sectionId.hashCode ^
    sectionName.hashCode ^
    teacherId.hashCode ^
    teacherName.hashCode ^
    roomName.hashCode ^
    semesterNo.hashCode ^
    date.hashCode ^
    startTime.hashCode ^
    endTime.hashCode ^
    status.hashCode ^
    sessionType.hashCode ^
    group.hashCode ^
    attendanceId.hashCode ^
    studentIds.hashCode ^
    synced.hashCode;
  }
}
