import 'dart:convert';

class Subject {
  final String subjectId;
  final String subjectName;
  final String batchId;
  final String branchId;
  final String subjectCode; // New parameter

  Subject({
    required this.subjectId,
    required this.subjectName,
    required this.batchId,
    required this.branchId,
    required this.subjectCode,
  });

  Subject copyWith({
    String? subjectId,
    String? subjectName,
    String? batchId,
    String? branchId,
    String? subjectCode,
  }) {
    return Subject(
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      batchId: batchId ?? this.batchId,
      branchId: branchId ?? this.branchId,
      subjectCode: subjectCode ?? this.subjectCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subjectId': subjectId,
      'subjectName': subjectName,
      'batchId': batchId,
      'branchId': branchId,
      'subjectCode': subjectCode, // Added here
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      subjectId: map['subjectId'] ?? "",
      subjectName: map['subjectName'] ?? "",
      batchId: map['batchId'] ?? "",
      branchId: map['branchId'] ?? "",
      subjectCode: map['subjectCode'] ?? "", // Added here
    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) =>
      Subject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Subject(subjectId: $subjectId, subjectName: $subjectName, batchId: $batchId, branchId: $branchId, subjectCode: $subjectCode)';
  }

  @override
  bool operator ==(covariant Subject other) {
    if (identical(this, other)) return true;

    return other.subjectId == subjectId &&
        other.subjectName == subjectName &&
        other.batchId == batchId &&
        other.branchId == branchId &&
        other.subjectCode == subjectCode;
  }

  @override
  int get hashCode {
    return subjectId.hashCode ^
        subjectName.hashCode ^
        batchId.hashCode ^
        branchId.hashCode ^
        subjectCode.hashCode;
  }
}
