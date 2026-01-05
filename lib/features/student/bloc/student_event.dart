import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:markme_student/features/student/models/student.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object?> get props => [];
}


class GetAllCoursesEvent extends StudentEvent {
  final String collegeId;
  const GetAllCoursesEvent({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}

class GetBatchesByBranchIdEvent extends StudentEvent {
  final String branchId;
  final String collegeId;
  const GetBatchesByBranchIdEvent(this.branchId,{required this.collegeId});

  @override
  List<Object?> get props => [branchId,collegeId];
}

class GetBranchesByCourseIdEvent extends StudentEvent {
  final String courseId;
  final String collegeId;
  const GetBranchesByCourseIdEvent(this.courseId,{required this.collegeId});

  @override
  List<Object?> get props => [courseId,collegeId];
}

class GetSectionsByBatchIdEvent extends StudentEvent {

  final String batchId;
  final String collegeId;

  const GetSectionsByBatchIdEvent({

    required this.batchId,
    required this.collegeId
  });

  @override
  List<Object?> get props => [batchId,collegeId];
}
class RegisterStudentEvent extends StudentEvent{
  final Student student;
  final File imageFile;
  final String collegeId;
  const RegisterStudentEvent(this.student,this.imageFile,{required this.collegeId});
  @override
  List<Object?> get props => [student];
}
