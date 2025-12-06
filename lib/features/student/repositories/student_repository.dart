import 'package:dartz/dartz.dart';
import 'package:markme_student/core/error/failure.dart';
import 'package:markme_student/core/models/academic_batch.dart';
import 'package:markme_student/core/models/branch.dart';
import 'package:markme_student/core/models/course.dart';
import 'package:markme_student/features/student/models/student.dart';

abstract class StudentRepository{
  Future<Either<AppFailure,List<Course>>> getAllCourses();
  Future<Either<AppFailure,List<Branch>>> getBranchesByCourseId(String courseId);
  Future<Either<AppFailure,List<AcademicBatch>>> getBatchesByBranchId(String branchId);
  Future<Either<AppFailure,List<String>>> getSectionsByBatchId({
    required String batchId,
  });
  Future<Either<AppFailure,String>> updateStudentSection(String uid, String sectionId) ;
  Future<Either<AppFailure,Student>> getStudent(String? rollNo,String? registrationNo);
  Future<Either<AppFailure, Unit>> deleteStudentCompletely(String uid);
}