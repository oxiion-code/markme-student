import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_student/features/auth/repositories/auth_repository.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_event.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_state.dart';
import 'package:markme_student/features/edit_profile/repositories/edit_profile_repository.dart';
import 'package:markme_student/features/student/repositories/student_repository.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AuthRepository authRepository;
  final StudentRepository studentRepository;
  final EditProfileRepository editProfileRepository;
  EditProfileBloc({
    required this.authRepository,
    required this.studentRepository,
    required this.editProfileRepository,
  }) : super(EditProfileInitial()) {
    on<UpdateProfileOfStudentEvent>(_onEditProfile);
    on<LoadSectionsForStudentEvent>(_onLoadSections);
    on<ChangeSectionOfStudentEvent>(_onChangeSection);
    on<UpdateStudentRegOrRollEvent>(_onUpdateRegOrRoll);
    on<GetSectionDetailsEvent>(_onLoadSectionDetails);
  }
  FutureOr<void> _onEditProfile(
    UpdateProfileOfStudentEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    final result = await authRepository.updateStudentData(
      student: event.student,
      profilePhoto: event.profilePhoto,
      collegeId: event.collegeId,
    );
    result.fold(
      (failure) => emit(EditProfileError(message: failure.message)),
      (student) => emit(EditProfileSuccess(student)),
    );
  }

  FutureOr<void> _onLoadSections(
    LoadSectionsForStudentEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    final result = await studentRepository.getSectionsByBatchId(
      batchId: event.batchId,
      collegeId: event.collegeId,
    );
    result.fold(
      (failure) {
        emit(EditProfileError(message: failure.message));
      },
      (sections) {
        emit(SectionsLoadedForStudent(sections: sections));
      },
    );
  }

  FutureOr<void> _onChangeSection(
    ChangeSectionOfStudentEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    final result = await studentRepository.updateStudentSection(
      event.studentId,
      event.sectionId,
      event.collegeId,
    );
    result.fold(
      (failure) {
        emit(EditProfileError(message: failure.message));
      },
      (sectionId) {
        emit(SectionChangedForStudent(sectionId: sectionId));
      },
    );
  }

  FutureOr<void> _onUpdateRegOrRoll(
    UpdateStudentRegOrRollEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    final result = await editProfileRepository.updateStudentRollOrReg(
      event.collegeId,
      event.studentId,
      event.rollNo,
      event.regNo,
    );
    result.fold(
      (failure) => emit(EditProfileError(message: failure.message)),
      (_) => emit(UpdatedStudentRegOrRoll()),
    );
  }

  FutureOr<void> _onLoadSectionDetails(
    GetSectionDetailsEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    final result = await editProfileRepository.getSectionDetails(
      event.collegeId,
      event.sectionId,
    );
    result.fold(
      (failure) => emit(EditProfileError(message: failure.message)),
      (section) => emit(LoadedSectionDetails(section: section)),
    );
  }
}
