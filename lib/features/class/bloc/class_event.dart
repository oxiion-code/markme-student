import 'package:equatable/equatable.dart';

class ClassEvent extends Equatable{
  const ClassEvent();
  @override
  List<Object?> get props => [];
}

class LoadTodayClassesEvent extends ClassEvent{
  final String sectionId;
  final String studentId;
  const LoadTodayClassesEvent({required this.sectionId, required this.studentId});
  @override
  List<Object?> get props => [];
}