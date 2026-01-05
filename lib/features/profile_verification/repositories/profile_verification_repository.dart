import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:markme_student/core/error/failure.dart';
import 'package:markme_student/features/profile_verification/models/qualification.dart';

abstract class ProfileVerificationRepository{
  Future<Either<AppFailure,String>> checkAccountVerificationStatus(String collegeId,String studentId);
Future<Either<AppFailure,Unit>> uploadVerificationDocuments(String collegeId,String studentId,Map<String,File> documents);
Future<Either<AppFailure,Unit>> uploadEducationalDetails(String studentId, String collegeId, List<Qualification> qualifications);
}