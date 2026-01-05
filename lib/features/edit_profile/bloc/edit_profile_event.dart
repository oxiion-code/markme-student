import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:markme_student/features/student/models/student.dart';

class EditProfileEvent extends Equatable {
  const EditProfileEvent();
  @override
  List<Object?> get props => [];
}

class UpdateProfileOfStudentEvent extends EditProfileEvent {
  final File? profilePhoto;
  final Student student;
  final String collegeId;
  const UpdateProfileOfStudentEvent({
    required this.profilePhoto,
    required this.student,
    required this.collegeId,
  });
  @override
  List<Object?> get props => [profilePhoto, student];
}

class ChangeSectionOfStudentEvent extends EditProfileEvent {
  final String studentId;
  final String sectionId;
  final String collegeId;
  const ChangeSectionOfStudentEvent({
    required this.sectionId,
    required this.studentId,
    required this.collegeId,
  });
  @override
  List<Object?> get props => [sectionId, studentId];
}

class LoadSectionsForStudentEvent extends EditProfileEvent {
  final String batchId;
  final String collegeId;
  const LoadSectionsForStudentEvent({
    required this.batchId,
    required this.collegeId,
  });
  @override
  List<Object?> get props => [batchId];
}

class UpdateStudentRegOrRollEvent extends EditProfileEvent {

  final String collegeId;
  final String studentId;
  final String? rollNo;
  final String? regNo;
  const UpdateStudentRegOrRollEvent({
    required this.collegeId,
    required this.studentId,
    required this.regNo,
    required this.rollNo,
  });
  @override
  List<Object?> get props => [collegeId,studentId,regNo,rollNo];
}
class GetSectionDetailsEvent extends EditProfileEvent{
  final String collegeId;
  final String sectionId;
  const GetSectionDetailsEvent({required this.sectionId, required this.collegeId});
  @override
  List<Object?> get props => [collegeId, sectionId];
}
