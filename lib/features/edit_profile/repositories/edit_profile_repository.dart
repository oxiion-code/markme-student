import 'package:dartz/dartz.dart';
import 'package:markme_student/core/error/failure.dart';
import 'package:markme_student/core/models/section.dart';

abstract class EditProfileRepository {
  Future<Either<AppFailure,Unit>> updateStudentRollOrReg(String collegeId,String studentId,String? rollNo, String? regNo);
  Future<Either<AppFailure,Section>> getSectionDetails(String collegeId, String sectionId);
}