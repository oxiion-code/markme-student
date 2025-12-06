import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:markme_student/features/student/models/student.dart';


abstract class AuthEvent extends Equatable{
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent{

}
class LogoutRequested extends AuthEvent{

}

class SendOtpEvent extends AuthEvent{
  final String phoneNumber;
  const SendOtpEvent(this.phoneNumber);
  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent{
  final String verificationId;
  final String otp;
  const VerifyOtpEvent(this.verificationId,this.otp);
  @override
  List<Object?> get props => [verificationId,otp];
}

class UpdateDataEvent extends AuthEvent{
  final Student student;
  final File file;
  const UpdateDataEvent(this.student,this.file);
  @override
  List<Object?> get props => [student,file];
}
