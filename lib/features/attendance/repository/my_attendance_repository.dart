import 'package:dartz/dartz.dart';
import 'package:markme_student/core/error/failure.dart';
import 'package:markme_student/features/attendance/models/subject_attendance.dart';

abstract class MyAttendanceRepository {
  Future<Either<AppFailure, List<SubjectAttendance>>> getSubjectWiseAttendance(
    String studentId,
    String sectionId,
      String collegeId
  );
}
