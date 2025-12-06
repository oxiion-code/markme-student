import 'dart:convert';

class Semester {
  final String semesterId;
  final String semesterNumber;
  final String branchId;
  const Semester({
    required this.semesterId,
    required this.semesterNumber,
    required this.branchId,
  });


  Semester copyWith({
    String? semesterId,
    String? semesterNumber,
    String? branchId,
  }) {
    return Semester(
      semesterId: semesterId ?? this.semesterId,
      semesterNumber: semesterNumber ?? this.semesterNumber,
      branchId: branchId ?? this.branchId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'semesterId': semesterId,
      'semesterNumber': semesterNumber,
      'branchId': branchId,
    };
  }

  factory Semester.fromMap(Map<String, dynamic> map) {
    return Semester(
      semesterId: map['semesterId'] as String,
      semesterNumber: map['semesterNumber'] as String,
      branchId: map['branchId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Semester.fromJson(String source) => Semester.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Semester(semesterId: $semesterId, semesterNumber: $semesterNumber, branchId: $branchId)';

  @override
  bool operator ==(covariant Semester other) {
    if (identical(this, other)) return true;

    return
      other.semesterId == semesterId &&
          other.semesterNumber == semesterNumber &&
          other.branchId == branchId;
  }

  @override
  int get hashCode => semesterId.hashCode ^ semesterNumber.hashCode ^ branchId.hashCode;
}
