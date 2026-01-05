import 'package:equatable/equatable.dart';

class MyAttendanceEvent extends  Equatable{
  const MyAttendanceEvent();
  @override
  List<Object?> get props => [];
}
class LoadMyAttendanceEvent extends MyAttendanceEvent{
  final String studentId;
  final String sectionId;
  final String collegeId;
  const LoadMyAttendanceEvent({required this.studentId, required this.sectionId, required this.collegeId});
  @override
  List<Object?> get props => [studentId,sectionId];
}