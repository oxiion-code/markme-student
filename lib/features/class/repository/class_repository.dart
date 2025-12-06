import 'package:dartz/dartz.dart';
import 'package:markme_student/core/error/failure.dart';
import 'package:markme_student/features/class/models/class_session_with_flag.dart';

abstract class ClassRepository {
  Stream<Either<AppFailure, List<ClassSessionWithFlag>>> streamTodayClasses(
      String sectionId, String studentId);
}
