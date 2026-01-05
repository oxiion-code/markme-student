import 'dart:io';

import 'package:equatable/equatable.dart';

import '../models/time_table.dart';


abstract class TimeTableEvent extends Equatable {
  const TimeTableEvent();
  @override
  List<Object?> get props => [];
}

class FetchTimeTableForStudentEvent extends TimeTableEvent{
  final String sectionId;
  final String collegeId;
  const FetchTimeTableForStudentEvent({required this.sectionId, required this.collegeId});
  @override
  List<Object?> get props => [sectionId];
}
