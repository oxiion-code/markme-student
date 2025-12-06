import 'package:equatable/equatable.dart';
import 'package:markme_student/features/attendance/models/subject_attendance.dart';

class MyAttendanceState extends Equatable{
  const MyAttendanceState();
  @override
  List<Object?> get props => [];
}

class MyAttendanceInitial extends MyAttendanceState{

}
class MyAttendanceLoading extends MyAttendanceState{

}
class MyAttendanceError extends MyAttendanceState{
  final String message;
  const MyAttendanceError(this.message);
  @override
  List<Object?> get props => [message];
}

class MyAttendanceLoaded extends MyAttendanceState{
  final List<SubjectAttendance> subjectWiseAttendance;
  const MyAttendanceLoaded({required this.subjectWiseAttendance});
  @override
  List<Object?> get props => [subjectWiseAttendance];
}
