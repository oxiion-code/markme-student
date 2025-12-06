import 'package:equatable/equatable.dart';
import 'package:markme_student/features/class/models/class_session_with_flag.dart';

class ClassState extends Equatable{
  const ClassState();
  @override
  List<Object?> get props => [];
}
class ClassInitial extends ClassState{

}
class ClassLoading extends ClassState{

}
class ClassError extends ClassState{
  final String message;
  const ClassError({required this.message});
  @override
  List<Object?> get props =>[message];
}
class TodayClassesLoaded extends ClassState{
  final List<ClassSessionWithFlag> loadedClasses;
  const TodayClassesLoaded({required this.loadedClasses});
  @override
  List<Object?> get props => [loadedClasses];
}