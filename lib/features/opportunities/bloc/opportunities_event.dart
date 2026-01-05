import 'package:equatable/equatable.dart';

import '../models/placement_form.dart';

abstract class OpportunitiesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPlacementSessionsEvent extends OpportunitiesEvent {
  final String collegeId;
  final String batchId;
  LoadPlacementSessionsEvent({required this.collegeId, required this.batchId});
  @override
  List<Object?> get props => [collegeId, batchId];
}

class LoadQualificationDetailsEvent extends OpportunitiesEvent {
  final String collegeId;
  final String studentId;
  LoadQualificationDetailsEvent({
    required this.collegeId,
    required this.studentId,
  });
  @override
  List<Object?> get props => [collegeId, studentId];
}

class LoadAppliedFormsEvent extends OpportunitiesEvent {
  final String studentId;
  LoadAppliedFormsEvent({
    required this.studentId,
  });
  @override
  List<Object?> get props => [studentId];
}

class SubmitApplicationEvent extends OpportunitiesEvent {
  final String collegeId;
  final String sessionId;
  final String studentId;
  final PlacementForm form;
  SubmitApplicationEvent({
    required this.sessionId,
    required this.studentId,
    required this.collegeId,
    required this.form,
  });
  @override
  List<Object?> get props => [collegeId,sessionId,studentId];
}
class DeleteApplicationEvent extends OpportunitiesEvent{
  final String collegeId;
  final String sessionId;
  final String studentId;
  DeleteApplicationEvent({required this.collegeId, required this.studentId, required this.sessionId});
  @override
  List<Object?> get props => [collegeId,sessionId,studentId];
}
