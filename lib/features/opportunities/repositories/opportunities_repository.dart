import 'package:dartz/dartz.dart';
import 'package:markme_student/core/error/failure.dart';
import 'package:markme_student/features/opportunities/models/placement_session.dart';
import 'package:markme_student/features/profile_verification/models/qualification.dart';

import '../models/placement_form.dart';
import '../models/student_application.dart';

abstract class OpportunitiesRepository {
  Future<Either<AppFailure, List<PlacementSession>>> loadPlacementSessions(
    String collegeId,
    String batchId,
  );
  Future<Either<AppFailure, List<Qualification>>> loadStudentQualifications(
    String collegeId,
    String studentId,
  );
  Future<Either<AppFailure, Unit>> submitPlacementApplication({
    required String collegeId,
    required String sessionId,
    required String studentId,
    required PlacementForm form,
  });
  Future<Either<AppFailure, List<StudentApplication>>>
  getStudentApplications(String studentId);
  Future<Either<AppFailure, Unit>> deleteStudentApplication({
    required String collegeId,
    required String sessionId,
    required String studentId,
  });
}
