
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/models/college_detail.dart';
import '../../student/models/student.dart';
import '../models/auth_info.dart';

abstract class AuthRepository {
  Future<Either<AppFailure, String>> sendOtp({
    required String phoneNumber,
  });
  Future<Either<AppFailure,AuthInfo>> verifyOtp({required String verificationId,required String otp});
  Future<Either<AppFailure, Student>> getUserdata({required String uid, required String collegeId});
  Future<Either<AppFailure, Student>> updateStudentData({required Student student, File? profilePhoto,required String collegeId}) ;
  Future<Either<AppFailure, void>> logout();
  Future<Either<AppFailure,List<CollegeDetail>>> loadAllColleges();
}

