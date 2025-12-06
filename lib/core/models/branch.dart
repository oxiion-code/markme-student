import 'dart:convert';

class Branch {
  final String branchId;
  final String branchName;
  final String courseId;
  const Branch({
    required this.branchId,
    required this.branchName,
    required this.courseId,
  });

  Branch copyWith({
    String? branchId,
    String? branchName,
    String? courseId,
  }) {
    return Branch(
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      courseId: courseId ?? this.courseId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'branchId': branchId,
      'branchName': branchName,
      'courseId': courseId,
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      branchId: map['branchId'] as String,
      branchName: map['branchName'] as String,
      courseId: map['courseId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Branch.fromJson(String source) => Branch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Branch(branchId: $branchId, branchName: $branchName, courseId: $courseId)';

  @override
  bool operator ==(covariant Branch other) {
    if (identical(this, other)) return true;

    return
      other.branchId == branchId &&
          other.branchName == branchName &&
          other.courseId == courseId;
  }

  @override
  int get hashCode => branchId.hashCode ^ branchName.hashCode ^ courseId.hashCode;
}
