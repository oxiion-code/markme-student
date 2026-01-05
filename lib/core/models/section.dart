
import 'dart:convert';

class Section {
  final String sectionId;
  final String sectionName;
  final String batchId;
  final String branchId;

  final int totalSeatsAllocated;
  final int availableSeats;

  final String? proctorId;
  final String? defaultRoom;
  final String? hodId;
  final String? hodName;
  final String? proctorName;

  final String courseId;
  final String currentSemesterId;
  final int currentSemesterNumber;

  Section({
    required this.sectionId,
    required this.sectionName,
    required this.batchId,
    required this.branchId,
    required this.totalSeatsAllocated,
    required this.availableSeats,
    this.proctorId,
    this.defaultRoom,
    this.hodId,
    this.hodName,
    this.proctorName,
    required this.courseId,
    required this.currentSemesterId,
    required this.currentSemesterNumber,
  });

  Section copyWith({
    String? sectionId,
    String? sectionName,
    String? batchId,
    String? branchId,
    int? totalSeatsAllocated,
    int? availableSeats,
    String? proctorId,
    String? defaultRoom,
    String? hodId,
    String? hodName,
    String? proctorName,
    String? courseId,
    String? currentSemesterId,
    int? currentSemesterNumber,
  }) {
    return Section(
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      batchId: batchId ?? this.batchId,
      branchId: branchId ?? this.branchId,
      totalSeatsAllocated:
      totalSeatsAllocated ?? this.totalSeatsAllocated,
      availableSeats: availableSeats ?? this.availableSeats,
      proctorId: proctorId ?? this.proctorId,
      defaultRoom: defaultRoom ?? this.defaultRoom,
      hodId: hodId ?? this.hodId,
      hodName: hodName ?? this.hodName,
      proctorName: proctorName ?? this.proctorName,
      courseId: courseId ?? this.courseId,
      currentSemesterId:
      currentSemesterId ?? this.currentSemesterId,
      currentSemesterNumber:
      currentSemesterNumber ?? this.currentSemesterNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sectionId': sectionId,
      'sectionName': sectionName,
      'batchId': batchId,
      'branchId': branchId,
      'totalSeatsAllocated': totalSeatsAllocated,
      'availableSeats': availableSeats,
      'proctorId': proctorId,
      'defaultRoom': defaultRoom,
      'hodId': hodId,
      'hodName': hodName,
      'proctorName': proctorName,
      'courseId': courseId,
      'currentSemesterId': currentSemesterId,
      'currentSemesterNumber': currentSemesterNumber,
    };
  }

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      sectionId: map['sectionId'] ?? '',
      sectionName: map['sectionName'] ?? '',
      batchId: map['batchId'] ?? '',
      branchId: map['branchId'] ?? '',
      totalSeatsAllocated:
      map['totalSeatsAllocated']?.toInt() ?? 0,
      availableSeats:
      map['availableSeats']?.toInt() ?? 0,
      proctorId: map['proctorId'],
      defaultRoom: map['defaultRoom'],
      hodId: map['hodId'],
      hodName: map['hodName'],
      proctorName: map['proctorName'],
      courseId: map['courseId'] ?? '',
      currentSemesterId: map['currentSemesterId'] ?? '',
      currentSemesterNumber:
      map['currentSemesterNumber']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Section.fromJson(String source) =>
      Section.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Section(sectionId: $sectionId, sectionName: $sectionName, batchId: $batchId, branchId: $branchId, totalSeatsAllocated: $totalSeatsAllocated, availableSeats: $availableSeats, proctorId: $proctorId, defaultRoom: $defaultRoom, hodId: $hodId, hodName: $hodName, proctorName: $proctorName, courseId: $courseId, currentSemesterId: $currentSemesterId, currentSemesterNumber: $currentSemesterNumber)';
  }

  @override
  bool operator ==(covariant Section other) {
    if (identical(this, other)) return true;

    return other.sectionId == sectionId &&
        other.sectionName == sectionName &&
        other.batchId == batchId &&
        other.branchId == branchId &&
        other.totalSeatsAllocated == totalSeatsAllocated &&
        other.availableSeats == availableSeats &&
        other.proctorId == proctorId &&
        other.defaultRoom == defaultRoom &&
        other.hodId == hodId &&
        other.hodName == hodName &&
        other.proctorName == proctorName &&
        other.courseId == courseId &&
        other.currentSemesterId == currentSemesterId &&
        other.currentSemesterNumber == currentSemesterNumber;
  }

  @override
  int get hashCode {
    return sectionId.hashCode ^
    sectionName.hashCode ^
    batchId.hashCode ^
    branchId.hashCode ^
    totalSeatsAllocated.hashCode ^
    availableSeats.hashCode ^
    proctorId.hashCode ^
    defaultRoom.hashCode ^
    hodId.hashCode ^
    hodName.hashCode ^
    proctorName.hashCode ^
    courseId.hashCode ^
    currentSemesterId.hashCode ^
    currentSemesterNumber.hashCode;
  }
}
