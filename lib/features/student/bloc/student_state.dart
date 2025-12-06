import 'package:equatable/equatable.dart';
import 'package:markme_student/features/student/models/student.dart';

import '../../../core/models/academic_batch.dart';
import '../../../core/models/branch.dart';
import '../../../core/models/course.dart';


abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentRegistrationLoading extends StudentState{}

class StudentRegistrationError extends StudentState{
  final String message;
  const StudentRegistrationError(this.message);

  @override
  List<Object?> get props => [message];
}

class StudentError extends StudentState {
  final String message;
  const StudentError(this.message);

  @override
  List<Object?> get props => [message];
}

class CoursesLoaded extends StudentState {
  final List<Course> courses;
  const CoursesLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}

class BatchesLoaded extends StudentState {
  final List<AcademicBatch> batches;
  const BatchesLoaded(this.batches);

  @override
  List<Object?> get props => [batches];
}

class BranchesLoaded extends StudentState {
  final List<Branch> branches;
  const BranchesLoaded(this.branches);

  @override
  List<Object?> get props => [branches];
}

class SectionsLoaded extends StudentState {
  final List<String> sections;
  const SectionsLoaded(this.sections);

  @override
  List<Object?> get props => [sections];
}
class StudentRegistered extends StudentState{
  final Student student;
  const StudentRegistered(this.student);
  @override
  List<Object?> get props => [student];
}
