import 'package:equatable/equatable.dart';

class ClassEvent extends Equatable{
  const ClassEvent();
  @override
  List<Object?> get props => [];
}

class LoadTodayClassesEvent extends ClassEvent{
  final String sectionId;
  final String studentId;
  final String collegeId;
  const LoadTodayClassesEvent({required this.sectionId, required this.studentId, required this.collegeId});
  @override
  List<Object?> get props => [sectionId,studentId,collegeId];
}