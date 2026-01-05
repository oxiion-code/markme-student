import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:markme_student/features/student/models/student.dart';


abstract class AuthEvent extends Equatable{
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent{
  final String collegeId;
  const CheckAuthStatus({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}
class LogoutRequested extends AuthEvent{

}
class LoadAllCollegesEvent extends AuthEvent{

}

class SendOtpEvent extends AuthEvent{
  final String phoneNumber;
  const SendOtpEvent(this.phoneNumber,);
  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent{
  final String verificationId;
  final String otp;
  final String collegeId;
  const VerifyOtpEvent(this.verificationId,this.otp,{required this.collegeId});
  @override
  List<Object?> get props => [verificationId,otp];
}

class UpdateDataEvent extends AuthEvent{
  final Student student;
  final File file;
  final String collegeId;
  const UpdateDataEvent(this.student,this.file,{required this.collegeId});
  @override
  List<Object?> get props => [student,file];
}
