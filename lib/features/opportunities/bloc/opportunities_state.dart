import 'package:equatable/equatable.dart';
import 'package:markme_student/features/opportunities/models/placement_session.dart';
import 'package:markme_student/features/opportunities/models/student_application.dart';
import 'package:markme_student/features/profile_verification/models/qualification.dart';

abstract class OpportunitiesState  extends Equatable{
  @override
  List<Object?> get props => [];
}
class PlacementsLoadedForStudent extends OpportunitiesState{
  final List<PlacementSession> sessions;
  PlacementsLoadedForStudent({required this.sessions});
  @override
  List<Object?> get props => [sessions];
}
class OpportunitiesLoading extends OpportunitiesState{

}
class OpportunitiesError extends OpportunitiesState{
  final String message;
  OpportunitiesError({required this.message});
  @override
  List<Object?> get props => [message];
}
class QualificationsLoaded extends OpportunitiesState{
  final List<Qualification> qualifications;
  QualificationsLoaded({required this.qualifications});
  @override
  List<Object?> get props => [qualifications];
}
class AppliedFormsLoaded extends OpportunitiesState{
  final List<StudentApplication> applications;
  AppliedFormsLoaded({required this.applications});
  @override
  List<Object?> get props => [applications];
}
class DeletedApplicationOfPlacement extends OpportunitiesState{
}
class SubmittedApplication extends OpportunitiesState{

}