import 'package:equatable/equatable.dart';

import '../../../core/models/course.dart';
import '../models/time_table.dart';


abstract class TimeTableState extends Equatable{
  const TimeTableState();
  @override
  List<Object?> get props => [];
}
class TimeTableInitial extends TimeTableState{

}
class TimeTableLoading extends TimeTableState{

}
class StudentTimeTableLoaded extends TimeTableState{
  final TimeTable timeTable;
  const StudentTimeTableLoaded({required this.timeTable});
  @override
  List<Object?> get props => [timeTable];
}
class TimeTableError extends TimeTableState{
  final String message;
  const TimeTableError({required this.message});
  @override
  List<Object?> get props => [message];
}