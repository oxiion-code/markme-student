import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:markme_student/features/student/models/student.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object?> get props => [];
}


class GetAllCoursesEvent extends StudentEvent {}

class GetBatchesByBranchIdEvent extends StudentEvent {
  final String branchId;
  const GetBatchesByBranchIdEvent(this.branchId);

  @override
  List<Object?> get props => [branchId];
}

class GetBranchesByCourseIdEvent extends StudentEvent {
  final String courseId;
  const GetBranchesByCourseIdEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class GetSectionsByBatchIdEvent extends StudentEvent {

  final String batchId;

  const GetSectionsByBatchIdEvent({

    required this.batchId,
  });

  @override
  List<Object?> get props => [batchId];
}
class RegisterStudentEvent extends StudentEvent{
  final Student student;
  final File imageFile;
  const RegisterStudentEvent(this.student,this.imageFile);
  @override
  List<Object?> get props => [student];
}
