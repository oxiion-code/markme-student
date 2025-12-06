import 'package:equatable/equatable.dart';

import '../../student/models/student.dart';
import '../models/auth_info.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String verificationId;
  const OtpSent(this.verificationId);

  @override
  List<Object?> get props => [verificationId];
}

class AuthenticationSuccess extends AuthState {
  final AuthInfo authInfo;
  final bool isNewUser;
  final Student? student;
  const AuthenticationSuccess({
    required this.authInfo,
    required this.isNewUser,
    this.student,
  });

  @override
  List<Object?> get props => [authInfo, isNewUser, student];
}

class UserAlreadyLoggedIn extends AuthState {
  final Student? student;
  const UserAlreadyLoggedIn(this.student);

  @override
  List<Object?> get props => [student];
}

/// **New state** for incomplete profile
class ProfileIncomplete extends AuthState {
  final Student student;
  const ProfileIncomplete(this.student);

  @override
  List<Object?> get props => [student];
}

class UnAuthenticated extends AuthState {}

class AuthError extends AuthState {
  final String error;
  const AuthError(this.error);

  @override
  List<Object?> get props => [error];
}

class LogoutSuccess extends AuthState {}

class StudentUpdateSuccess extends AuthState {
  final Student student;
  const StudentUpdateSuccess(this.student);

  @override
  List<Object?> get props => [student];
}
