import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_student/features/profile_verification/bloc/profile_verification_event.dart';
import 'package:markme_student/features/profile_verification/bloc/profile_verification_state.dart';
import 'package:markme_student/features/profile_verification/repositories/profile_verification_repository.dart';

class ProfileVerificationBloc
    extends Bloc<ProfileVerificationEvent, ProfileVerificationState> {
  final ProfileVerificationRepository repository;

  ProfileVerificationBloc({required this.repository})
      : super(ProfileVerificationLoading()) {
    // Upload education details
    on<UploadEducationDetailsEvent>(_onUploadEducationDetails);

    // Upload documents
    on<UploadDocumentsForVerificationEvent>(_onUploadDocuments);

    // Check verification status
    on<CheckAccountVerificationStatus>(_onCheckVerificationStatus);
  }

  // -------------------------------
  // Upload Education Details
  // -------------------------------
  Future<void> _onUploadEducationDetails(
      UploadEducationDetailsEvent event,
      Emitter<ProfileVerificationState> emit,
      ) async {
    emit(ProfileVerificationLoading());

    final result = await repository.uploadEducationalDetails(
      event.studentId,
      event.collegeId,
      event.qualifications,
    );

    result.fold(
          (failure) => emit(
        ProfileVerificationError(message: failure.message),
      ),
          (_) => emit(QualificationDetailsUploaded()),
    );
  }

  // -------------------------------
  // Upload Verification Documents
  // -------------------------------
  Future<void> _onUploadDocuments(
      UploadDocumentsForVerificationEvent event,
      Emitter<ProfileVerificationState> emit,
      ) async {
    emit(ProfileVerificationLoading());

    final result = await repository.uploadVerificationDocuments(
      event.collegeId,
      event.studentId,
      event.documents,
    );

    result.fold(
          (failure) => emit(
        ProfileVerificationError(message: failure.message),
      ),
          (_) => emit(DocumentsUploaded()),
    );
  }

  // -------------------------------
  // Check Account Verification Status
  // -------------------------------
  Future<void> _onCheckVerificationStatus(
      CheckAccountVerificationStatus event,
      Emitter<ProfileVerificationState> emit,
      ) async {
    emit(ProfileVerificationLoading());
    final result = await repository.checkAccountVerificationStatus(
      event.collegeId,
      event.studentId,
    );
    result.fold(
          (failure) => emit(
        ProfileVerificationError(message: failure.message),
      ),
          (status) => emit(
        ProfileVerificationStatusLoaded(status: status),
      ),
    );
  }
}
