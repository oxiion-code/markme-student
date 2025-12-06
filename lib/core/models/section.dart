import 'dart:convert';
import 'package:collection/collection.dart';

class Section {
  final String sectionId;
  final String sectionName;
  final String batchId;
  final String branchId;
  final List<String> studentIds;
  final String? proctorId;
  final String? defaultRoom;
  final String? hodId;
  final String? hodName;
  final String? proctorName;

  Section({
    required this.sectionId,
    required this.sectionName,
    required this.batchId,
    required this.branchId,
    required this.studentIds,
    this.proctorId,
    this.defaultRoom,
    this.hodId,
    this.hodName,
    this.proctorName,
  });

  Section copyWith({
    String? sectionId,
    String? sectionName,
    String? batchId,
    String? branchId,
    List<String>? studentIds,
    String? proctorId,
    String? defaultRoom,
    String? hodId,
    String? hodName,
    String? proctorName,
  }) {
    return Section(
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      batchId: batchId ?? this.batchId,
      branchId: branchId ?? this.branchId,
      studentIds: studentIds ?? this.studentIds,
      proctorId: proctorId ?? this.proctorId,
      defaultRoom: defaultRoom ?? this.defaultRoom,
      hodId: hodId ?? this.hodId,
      hodName: hodName ?? this.hodName,
      proctorName: proctorName ?? this.proctorName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sectionId': sectionId,
      'sectionName': sectionName,
      'batchId': batchId,
      'branchId': branchId,
      'studentIds': studentIds,
      'proctorId': proctorId,
      'defaultRoom': defaultRoom,
      'hodId': hodId,
      'hodName': hodName,
      'proctorName': proctorName,
    };
  }

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      sectionId: map['sectionId'] as String,
      sectionName: map['sectionName'] as String,
      batchId: map['batchId'] as String,
      branchId: map['branchId'] as String,
      studentIds: List<String>.from(map['studentIds'] as List),
      proctorId: map['proctorId'] != null ? map['proctorId'] as String : null,
      defaultRoom: map['defaultRoom'] != null ? map['defaultRoom'] as String : null,
      hodId: map['hodId'] != null ? map['hodId'] as String : null,
      hodName: map['hodName'] != null ? map['hodName'] as String : null,
      proctorName: map['proctorName'] != null ? map['proctorName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Section.fromJson(String source) =>
      Section.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Section(sectionId: $sectionId, sectionName: $sectionName, batchId: $batchId, branchId: $branchId, studentIds: $studentIds, proctorId: $proctorId, defaultRoom: $defaultRoom, hodId: $hodId, hodName: $hodName, proctorName: $proctorName)';
  }

  @override
  bool operator ==(covariant Section other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.sectionId == sectionId &&
        other.sectionName == sectionName &&
        other.batchId == batchId &&
        other.branchId == branchId &&
        listEquals(other.studentIds, studentIds) &&
        other.proctorId == proctorId &&
        other.defaultRoom == defaultRoom &&
        other.hodId == hodId &&
        other.hodName == hodName &&
        other.proctorName == proctorName;
  }

  @override
  int get hashCode {
    return sectionId.hashCode ^
    sectionName.hashCode ^
    batchId.hashCode ^
    branchId.hashCode ^
    studentIds.hashCode ^
    proctorId.hashCode ^
    defaultRoom.hashCode ^
    hodId.hashCode ^
    hodName.hashCode ^
    proctorName.hashCode;
  }
}
