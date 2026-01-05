
import 'dart:convert';

class PlacementForm {
  final String? applicationId;
  final String? sessionId;
  final String? companyId;
  final String? companyName;
  final String? jobTitle;

  // Student Info
  final String? studentId;
  final String? studentName;
  final String? registrationNo;
  final String? courseId;
  final String? batchId;

  // 10th Details
  final String? tenthCollegeName;
  final String? tenthCertificateUrl;
  final String? tenthCgpaOrPercentage;

  // 12th Details
  final String? twelfthCollegeName;
  final String? twelfthCertificateUrl;
  final String? twelfthCgpaOrPercentage;

  // Graduation Details
  final String? graduationCollegeName;
  final String? graduationCertificateUrl;
  final String? graduationCgpaOrPercentage;

  // Masters Details
  final String? mastersCollegeName;
  final String? mastersCertificateUrl;
  final String? mastersCgpaOrPercentage;

  // Undertaking
  final String? undertakingDescription;
  final String? undertakingDate;

  // Signature
  final String? signatureUrl;

  // Selection
  final bool? isSelected;

  final String? createdAt;

  const PlacementForm({
    this.applicationId,
    this.sessionId,
    this.companyId,
    this.companyName,
    this.jobTitle,
    this.studentId,
    this.studentName,
    this.registrationNo,
    this.courseId,
    this.batchId,
    this.tenthCollegeName,
    this.tenthCertificateUrl,
    this.tenthCgpaOrPercentage,
    this.twelfthCollegeName,
    this.twelfthCertificateUrl,
    this.twelfthCgpaOrPercentage,
    this.graduationCollegeName,
    this.graduationCertificateUrl,
    this.graduationCgpaOrPercentage,
    this.mastersCollegeName,
    this.mastersCertificateUrl,
    this.mastersCgpaOrPercentage,
    this.undertakingDescription,
    this.undertakingDate,
    this.signatureUrl,
    this.isSelected,
    this.createdAt,
  });

  /// 🔁 copyWith
  PlacementForm copyWith({
    String? applicationId,
    String? sessionId,
    String? companyId,
    String? companyName,
    String? jobTitle,
    String? studentId,
    String? studentName,
    String? registrationNo,
    String? courseId,
    String? batchId,
    String? tenthCollegeName,
    String? tenthCertificateUrl,
    String? tenthCgpaOrPercentage,
    String? twelfthCollegeName,
    String? twelfthCertificateUrl,
    String? twelfthCgpaOrPercentage,
    String? graduationCollegeName,
    String? graduationCertificateUrl,
    String? graduationCgpaOrPercentage,
    String? mastersCollegeName,
    String? mastersCertificateUrl,
    String? mastersCgpaOrPercentage,
    String? undertakingDescription,
    String? undertakingDate,
    String? signatureUrl,
    bool? isSelected,
    String? createdAt,
  }) {
    return PlacementForm(
      applicationId: applicationId ?? this.applicationId,
      sessionId: sessionId ?? this.sessionId,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      registrationNo: registrationNo ?? this.registrationNo,
      courseId: courseId ?? this.courseId,
      batchId: batchId ?? this.batchId,
      tenthCollegeName: tenthCollegeName ?? this.tenthCollegeName,
      tenthCertificateUrl:
      tenthCertificateUrl ?? this.tenthCertificateUrl,
      tenthCgpaOrPercentage:
      tenthCgpaOrPercentage ?? this.tenthCgpaOrPercentage,
      twelfthCollegeName:
      twelfthCollegeName ?? this.twelfthCollegeName,
      twelfthCertificateUrl:
      twelfthCertificateUrl ?? this.twelfthCertificateUrl,
      twelfthCgpaOrPercentage:
      twelfthCgpaOrPercentage ?? this.twelfthCgpaOrPercentage,
      graduationCollegeName:
      graduationCollegeName ?? this.graduationCollegeName,
      graduationCertificateUrl:
      graduationCertificateUrl ?? this.graduationCertificateUrl,
      graduationCgpaOrPercentage:
      graduationCgpaOrPercentage ?? this.graduationCgpaOrPercentage,
      mastersCollegeName:
      mastersCollegeName ?? this.mastersCollegeName,
      mastersCertificateUrl:
      mastersCertificateUrl ?? this.mastersCertificateUrl,
      mastersCgpaOrPercentage:
      mastersCgpaOrPercentage ?? this.mastersCgpaOrPercentage,
      undertakingDescription:
      undertakingDescription ?? this.undertakingDescription,
      undertakingDate: undertakingDate ?? this.undertakingDate,
      signatureUrl: signatureUrl ?? this.signatureUrl,
      isSelected: isSelected ?? this.isSelected,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 📤 toMap
  Map<String, dynamic> toMap() {
    return {
      'applicationId': applicationId,
      'sessionId': sessionId,
      'companyId': companyId,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'studentId': studentId,
      'studentName': studentName,
      'registrationNo': registrationNo,
      'courseId': courseId,
      'batchId': batchId,
      'tenthCollegeName': tenthCollegeName,
      'tenthCertificateUrl': tenthCertificateUrl,
      'tenthCgpaOrPercentage': tenthCgpaOrPercentage,
      'twelfthCollegeName': twelfthCollegeName,
      'twelfthCertificateUrl': twelfthCertificateUrl,
      'twelfthCgpaOrPercentage': twelfthCgpaOrPercentage,
      'graduationCollegeName': graduationCollegeName,
      'graduationCertificateUrl': graduationCertificateUrl,
      'graduationCgpaOrPercentage': graduationCgpaOrPercentage,
      'mastersCollegeName': mastersCollegeName,
      'mastersCertificateUrl': mastersCertificateUrl,
      'mastersCgpaOrPercentage': mastersCgpaOrPercentage,
      'undertakingDescription': undertakingDescription,
      'undertakingDate': undertakingDate,
      'signatureUrl': signatureUrl,
      'isSelected': isSelected,
      'createdAt': createdAt,
    };
  }

  /// 🔄 fromMap
  factory PlacementForm.fromMap(Map<String, dynamic> map) {
    return PlacementForm(
      applicationId: map['applicationId'],
      sessionId: map['sessionId'],
      companyId: map['companyId'],
      companyName: map['companyName'],
      jobTitle: map['jobTitle'],
      studentId: map['studentId'],
      studentName: map['studentName'],
      registrationNo: map['registrationNo'],
      courseId: map['courseId'],
      batchId: map['batchId'],
      tenthCollegeName: map['tenthCollegeName'],
      tenthCertificateUrl: map['tenthCertificateUrl'],
      tenthCgpaOrPercentage: map['tenthCgpaOrPercentage'],
      twelfthCollegeName: map['twelfthCollegeName'],
      twelfthCertificateUrl: map['twelfthCertificateUrl'],
      twelfthCgpaOrPercentage: map['twelfthCgpaOrPercentage'],
      graduationCollegeName: map['graduationCollegeName'],
      graduationCertificateUrl: map['graduationCertificateUrl'],
      graduationCgpaOrPercentage: map['graduationCgpaOrPercentage'],
      mastersCollegeName: map['mastersCollegeName'],
      mastersCertificateUrl: map['mastersCertificateUrl'],
      mastersCgpaOrPercentage: map['mastersCgpaOrPercentage'],
      undertakingDescription: map['undertakingDescription'],
      undertakingDate: map['undertakingDate'],
      signatureUrl: map['signatureUrl'],
      isSelected: map['isSelected'],
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlacementForm.fromJson(String source) =>
      PlacementForm.fromMap(json.decode(source));

  @override
  String toString() =>
      'PlacementForm(applicationId: $applicationId, studentId: $studentId, company: $companyName, job: $jobTitle)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PlacementForm &&
              other.applicationId == applicationId;

  @override
  int get hashCode => applicationId.hashCode;
}
