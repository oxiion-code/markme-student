
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../student/models/student.dart';
import '../models/auth_info.dart';

abstract class AuthRepository {
  Future<Either<AppFailure, String>> sendOtp({
    required String phoneNumber,
  });
  Future<Either<AppFailure,AuthInfo>> verifyOtp({required String verificationId,required String otp});
  Future<Either<AppFailure, Student>> getUserdata({required String uid});
  Future<Either<AppFailure, Student>> updateStudentData({required Student student, File? profilePhoto}) ;
  Future<Either<AppFailure, void>> logout();
}

