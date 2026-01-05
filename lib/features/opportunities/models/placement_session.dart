import 'eligibility.dart';

class PlacementSession {
  final String sessionId;
  final String sessionName;

  // Company Info
  final String companyId;
  final String companyName;

  // Role / Drive Info
  final String role;
  final String driveType; // On-campus / Off-campus / Pool
  final String description;
  final String location; // venue / city

  // Eligibility
  final Eligibility eligibility;
  final List<String> requiredSkills;

  // Dates
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  // Meta
  final String status; // upcoming / live / closed
  final String formId;
  final String collegeId;

  const PlacementSession({
    required this.sessionId,
    required this.sessionName,
    required this.companyId,
    required this.companyName,
    required this.role,
    required this.driveType,
    required this.description,
    required this.location,
    required this.eligibility,
    required this.requiredSkills,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.status,
    required this.formId,
    required this.collegeId,
  });

  /// 🔁 copyWith
  PlacementSession copyWith({
    String? sessionId,
    String? sessionName,
    String? companyId,
    String? companyName,
    String? role,
    String? driveType,
    String? description,
    String? location,
    Eligibility? eligibility,
    List<String>? requiredSkills,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    String? status,
    String? formId,
    String? collegeId,
  }) {
    return PlacementSession(
      sessionId: sessionId ?? this.sessionId,
      sessionName: sessionName ?? this.sessionName,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      role: role ?? this.role,
      driveType: driveType ?? this.driveType,
      description: description ?? this.description,
      location: location ?? this.location,
      eligibility: eligibility ?? this.eligibility,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      formId: formId ?? this.formId,
      collegeId: collegeId ?? this.collegeId,
    );
  }

  /// 🔄 fromJson
  factory PlacementSession.fromJson(Map<String, dynamic> json) {
    return PlacementSession(
      sessionId: json['sessionId'] ?? '',
      sessionName: json['sessionName'] ?? '',
      companyId: json['companyId'] ?? '',
      companyName: json['companyName'] ?? '',
      role: json['role'] ?? '',
      driveType: json['driveType'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      eligibility: Eligibility.fromJson(json['eligibility'] ?? {}),
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'] ?? 'upcoming',
      formId: json['formId'] ?? '',
      collegeId: json['collegeId'] ?? '',
    );
  }

  /// 📤 toJson
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'sessionName': sessionName,
      'companyId': companyId,
      'companyName': companyName,
      'role': role,
      'driveType': driveType,
      'description': description,
      'location': location,
      'eligibility': eligibility.toJson(),
      'requiredSkills': requiredSkills,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'formId': formId,
      'collegeId': collegeId,
    };
  }

  /// 🧠 Helpers
  bool get isLive =>
      status == 'live' &&
          DateTime.now().isAfter(startDate) &&
          DateTime.now().isBefore(endDate);

  bool get isUpcoming =>
      status == 'upcoming' && DateTime.now().isBefore(startDate);

  bool get isClosed =>
      status == 'closed' || DateTime.now().isAfter(endDate);

  @override
  String toString() =>
      'PlacementSession(sessionName: $sessionName, company: $companyName, role: $role)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PlacementSession && sessionId == other.sessionId;

  @override
  int get hashCode => sessionId.hashCode;
}
