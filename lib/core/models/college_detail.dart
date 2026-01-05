import 'dart:convert';
import 'package:hive/hive.dart';
import 'college_schedule.dart';

part 'college_detail.g.dart';

@HiveType(typeId: 2) // ⚠️ must be UNIQUE
class CollegeDetail extends HiveObject {

  @HiveField(0)
  final String? bannerLink;

  @HiveField(1)
  final String collegeName;

  @HiveField(2)
  final bool isSuperAdminExist;

  @HiveField(3)
  final String? logo;

  @HiveField(4)
  final String id;

  @HiveField(5)
  final CollegeSchedule? collegeSchedule;

   CollegeDetail({
    this.bannerLink,
    required this.collegeName,
    required this.isSuperAdminExist,
    this.logo,
    required this.id,
    this.collegeSchedule,
  });

  CollegeDetail copyWith({
    String?bannerLink,
    String? collegeName,
    bool? isSuperAdminExist,
    String? logo,
    String? id,
    CollegeSchedule? collegeSchedule,
  }) {
    return CollegeDetail(
      bannerLink: bannerLink ?? this.bannerLink,
      collegeName: collegeName ?? this.collegeName,
      isSuperAdminExist: isSuperAdminExist ?? this.isSuperAdminExist,
      logo: logo ?? this.logo,
      id: id ?? this.id,
      collegeSchedule: collegeSchedule ?? this.collegeSchedule,
    );
  }

  /// 🔹 Firestore / API
  Map<String, dynamic> toMap() => {
    'collegeBanner': bannerLink,
    'collegeName': collegeName,
    'isSuperAdminExist': isSuperAdminExist,
    'logo': logo,
    'id': id,
    'collegeSchedule': collegeSchedule?.toMap(),
  };

  factory CollegeDetail.fromMap(Map<String, dynamic> map) {
    return CollegeDetail(
      bannerLink: map['bannerLink'],
      collegeName: map['collegeName'],
      isSuperAdminExist: map['isSuperAdminExist'] ?? false,
      logo: map['logo'],
      id: map['id'],
      collegeSchedule: map['collegeSchedule'] != null
          ? CollegeSchedule.fromMap(
        Map<String, dynamic>.from(map['collegeSchedule']),
      )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CollegeDetail.fromJson(String source) =>
      CollegeDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CollegeDetail(id: $id, collegeName: $collegeName)';
  }
}
