import 'dart:convert';

class StudentApplication {
  final String applicationId;
  final String sessionId;
  final String companyId;
  final String companyName;
  final String jobTitle;

  /// applied | selected | rejected | withdrawn
  final String status;

  /// ISO string OR server timestamp converted to string
  final String appliedAt;

  const StudentApplication({
    required this.applicationId,
    required this.sessionId,
    required this.companyId,
    required this.companyName,
    required this.jobTitle,
    required this.status,
    required this.appliedAt,
  });

  /// 🔁 copyWith
  StudentApplication copyWith({
    String? applicationId,
    String? sessionId,
    String? companyId,
    String? companyName,
    String? jobTitle,
    String? status,
    String? appliedAt,
  }) {
    return StudentApplication(
      applicationId: applicationId ?? this.applicationId,
      sessionId: sessionId ?? this.sessionId,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }

  /// 📤 toMap (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'applicationId': applicationId,
      'sessionId': sessionId,
      'companyId': companyId,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'status': status,
      'appliedAt': appliedAt,
    };
  }

  /// 🔄 fromMap
  factory StudentApplication.fromMap(Map<String, dynamic> map) {
    return StudentApplication(
      applicationId: map['applicationId'] ?? '',
      sessionId: map['sessionId'] ?? '',
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      status: map['status'] ?? 'applied',
      appliedAt: map['appliedAt'] ?? '',
    );
  }

  /// JSON helpers
  String toJson() => json.encode(toMap());

  factory StudentApplication.fromJson(String source) =>
      StudentApplication.fromMap(json.decode(source));

  @override
  String toString() =>
      'StudentApplication(applicationId: $applicationId, company: $companyName, job: $jobTitle, status: $status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StudentApplication &&
              other.applicationId == applicationId;

  @override
  int get hashCode => applicationId.hashCode;
}
