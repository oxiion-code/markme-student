class TimeTable {
  final String courseId;
  final String courseName;
  final String pdfUrl;
  final DateTime uploadedAt;
  final String teacherId;
  final String semesterId;   // new field
  final String semesterName; // new field

  TimeTable({
    required this.courseId,
    required this.courseName,
    required this.pdfUrl,
    required this.uploadedAt,
    required this.teacherId,
    required this.semesterId,
    required this.semesterName,
  });

  // Firestore → Dart
  factory TimeTable.fromMap(Map<String, dynamic> map) {
    return TimeTable(
      courseId: map['courseId'] ?? '',
      courseName: map['courseName'] ?? '',
      pdfUrl: map['pdfUrl'] ?? '',
      uploadedAt: DateTime.tryParse(map['uploadedAt'] ?? '') ?? DateTime.now(),
      teacherId: map['teacherId'] ?? '',
      semesterId: map['semesterId'] ?? '',
      semesterName: map['semesterName'] ?? '',
    );
  }

  // Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'pdfUrl': pdfUrl,
      'uploadedAt': uploadedAt.toIso8601String(),
      'teacherId': teacherId,
      'semesterId': semesterId,
      'semesterName': semesterName,
    };
  }

  /// copyWith method
  TimeTable copyWith({
    String? courseId,
    String? courseName,
    String? pdfUrl,
    DateTime? uploadedAt,
    String? teacherId,
    String? semesterId,
    String? semesterName,
  }) {
    return TimeTable(
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      teacherId: teacherId ?? this.teacherId,
      semesterId: semesterId ?? this.semesterId,
      semesterName: semesterName ?? this.semesterName,
    );
  }
}
