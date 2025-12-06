// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AcademicBatch {
  final String batchId;
  final String branchId;
  final String startYear;
  final String endYear;
  AcademicBatch({
    required this.batchId,
    required this.branchId,
    required this.startYear,
    required this.endYear,
  });

  AcademicBatch copyWith({
    String? batchId,
    String? branchId,
    String? startYear,
    String? endYear,
  }) {
    return AcademicBatch(
      batchId: batchId ?? this.batchId,
      branchId: branchId ?? this.branchId,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'batchId': batchId,
      'branchId': branchId,
      'startYear': startYear,
      'endYear': endYear,
    };
  }

  factory AcademicBatch.fromMap(Map<String, dynamic> map) {
    return AcademicBatch(
      batchId: map['batchId'] as String,
      branchId: map['branchId'] as String,
      startYear: map['startYear'] as String,
      endYear: map['endYear'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AcademicBatch.fromJson(String source) => AcademicBatch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AcademicBatch(batchId: $batchId, branchId: $branchId, startYear: $startYear, endYear: $endYear)';
  }

  @override
  bool operator ==(covariant AcademicBatch other) {
    if (identical(this, other)) return true;

    return
      other.batchId == batchId &&
          other.branchId == branchId &&
          other.startYear == startYear &&
          other.endYear == endYear;
  }

  @override
  int get hashCode {
    return batchId.hashCode ^
    branchId.hashCode ^
    startYear.hashCode ^
    endYear.hashCode;
  }
}
