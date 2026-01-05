import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:markme_student/features/profile_verification/models/qualification.dart';

abstract class ProfileVerificationEvent extends Equatable{

}
class UploadEducationDetailsEvent extends ProfileVerificationEvent{
  final List<Qualification> qualifications;
  final String collegeId;
  final String studentId;
  UploadEducationDetailsEvent({required this.qualifications, required this.collegeId, required this.studentId});
  @override
  List<Object?> get props => [qualifications];
}

class UploadDocumentsForVerificationEvent
    extends ProfileVerificationEvent {
  final String studentId;
  final String collegeId;
  final Map<String, File> documents;

  UploadDocumentsForVerificationEvent({
    required this.studentId,
    required this.documents,
    required this.collegeId
  });
  @override
  List<Object?> get props => [studentId,collegeId,documents];
}
class CheckAccountVerificationStatus extends ProfileVerificationEvent {
  final String collegeId;
  final String studentId;

  CheckAccountVerificationStatus({
    required this.collegeId,
    required this.studentId,
  });

  @override
  List<Object?> get props => [collegeId, studentId];
}



