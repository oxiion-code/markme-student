import 'dart:convert';

class Course {
  final String courseId;
  final String courseName;
  const Course({
    required this.courseId,
    required this.courseName,
  });

  Course copyWith({
    String? courseId,
    String? courseName,
  }) {
    return Course(
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseId': courseId,
      'courseName': courseName,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      courseId: map['courseId'] as String,
      courseName: map['courseName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Course(courseId: $courseId, courseName: $courseName)';

  @override
  bool operator ==(covariant Course other) {
    if (identical(this, other)) return true;

    return
      other.courseId == courseId &&
          other.courseName == courseName;
  }

  @override
  int get hashCode => courseId.hashCode ^ courseName.hashCode;
}
