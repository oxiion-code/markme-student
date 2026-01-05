import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/opportunities_event.dart';
import '../bloc/opportunities_state.dart';
import '../repositories/opportunities_repository.dart';

class OpportunitiesBloc extends Bloc<OpportunitiesEvent, OpportunitiesState> {
  final OpportunitiesRepository repository;

  OpportunitiesBloc({required this.repository})
    : super(OpportunitiesLoading()) {
    on<LoadPlacementSessionsEvent>(_onLoadPlacementSessions);
    on<LoadQualificationDetailsEvent>(_onLoadQualifications);
    on<LoadAppliedFormsEvent>(_onLoadAppliedForms);
    on<SubmitApplicationEvent>(_onSubmitApplication);
    on<DeleteApplicationEvent>(_onDeleteApplication);
  }

  Future<void> _onLoadPlacementSessions(
    LoadPlacementSessionsEvent event,
    Emitter<OpportunitiesState> emit,
  ) async {
    emit(OpportunitiesLoading());

    final result = await repository.loadPlacementSessions(
      event.collegeId,
      event.batchId,
    );

    result.fold(
      (failure) {
        emit(
          OpportunitiesError(
            message: failure.message ?? 'Something went wrong',
          ),
        );
      },
      (sessions) {
        emit(PlacementsLoadedForStudent(sessions: sessions));
      },
    );
  }

  FutureOr<void> _onLoadQualifications(
    LoadQualificationDetailsEvent event,
    Emitter<OpportunitiesState> emit,
  ) async {
    emit(OpportunitiesLoading());

    final result = await repository.loadStudentQualifications(
      event.collegeId,
      event.studentId,
    );
    result.fold(
      (failure) {
        emit(
          OpportunitiesError(
            message: failure.message ?? 'Something went wrong',
          ),
        );
      },
      (qualifications) {
        emit(QualificationsLoaded(qualifications: qualifications));
      },
    );
  }

  FutureOr<void> _onLoadAppliedForms(
    LoadAppliedFormsEvent event,
    Emitter<OpportunitiesState> emit,
  ) async {
    emit(OpportunitiesLoading());
    final result = await repository.getStudentApplications(event.studentId);
    result.fold(
      (failure) => emit(OpportunitiesError(message: failure.message)),
      (applications) => emit(AppliedFormsLoaded(applications: applications)),
    );
  }

  FutureOr<void> _onSubmitApplication(
    SubmitApplicationEvent event,
    Emitter<OpportunitiesState> emit,
  ) async {
    emit(OpportunitiesLoading());
    final result = await repository.submitPlacementApplication(
      sessionId: event.sessionId,
      collegeId: event.collegeId,
      form: event.form,
      studentId: event.studentId,
    );
    result.fold(
      (failure) => emit(OpportunitiesError(message: failure.message)),
      (_) => emit(SubmittedApplication()),
    );
  }

  FutureOr<void> _onDeleteApplication(
    DeleteApplicationEvent event,
    Emitter<OpportunitiesState> emit,
  ) async {
    emit(OpportunitiesLoading());
    final result = await repository.deleteStudentApplication(
      sessionId: event.sessionId,
      collegeId: event.collegeId,
      studentId: event.studentId,
    );
    result.fold(
          (failure) => emit(OpportunitiesError(message: failure.message)),
          (_) => emit(SubmittedApplication()),
    );
  }
}
