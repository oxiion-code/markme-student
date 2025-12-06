import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../models/time_table.dart';


abstract class TimeTableRepository{
  Future<Either<AppFailure,TimeTable>> fetchTimeTableForStudent(String sectionId);
}