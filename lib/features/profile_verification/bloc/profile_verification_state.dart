import 'package:equatable/equatable.dart';

abstract class ProfileVerificationState extends Equatable{
  const ProfileVerificationState();
  @override
  List<Object?> get props => [];
}
class ProfileVerificationLoading extends ProfileVerificationState{

}
class DocumentsUploaded extends  ProfileVerificationState{

}
class QualificationDetailsUploaded extends ProfileVerificationState{

}
class ProfileVerificationStatusLoaded extends ProfileVerificationState{
  final String status;
  const ProfileVerificationStatusLoaded({required this.status});
  @override
  List<Object?> get props => [status];
}

class ProfileVerificationError extends ProfileVerificationState{
  final String message;
  const ProfileVerificationError({required this.message});
  @override
  List<Object?> get props => [message];
}

