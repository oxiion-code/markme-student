import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:markme_student/features/student/models/student.dart';

class EditProfileEvent extends Equatable{
  const EditProfileEvent();
  @override
  List<Object?> get props => [];
}
class UpdateProfileOfStudentEvent extends EditProfileEvent{
  final File? profilePhoto;
  final Student student;
  const UpdateProfileOfStudentEvent({required this.profilePhoto, required this.student});
  @override
  List<Object?> get props => [profilePhoto, student];
}

class ChangeSectionOfStudentEvent extends EditProfileEvent{
  final String studentId;
  final String sectionId;
  const ChangeSectionOfStudentEvent({required this.sectionId,required this.studentId});
  @override
  List<Object?> get props => [sectionId,studentId];
}
class LoadSectionsForStudentEvent extends EditProfileEvent{
  final String batchId;
  const LoadSectionsForStudentEvent({required this.batchId});
  @override
  List<Object?> get props => [batchId];
}