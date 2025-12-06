import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_student/features/auth/repositories/auth_repository.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_event.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_state.dart';
import 'package:markme_student/features/student/repositories/student_repository.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AuthRepository authRepository;
  final StudentRepository studentRepository;
  EditProfileBloc({
    required this.authRepository,
    required this.studentRepository,
  }) : super(EditProfileInitial()) {
    on<UpdateProfileOfStudentEvent>(_onEditProfile);
    on<LoadSectionsForStudentEvent>(_onLoadSections);
    on<ChangeSectionOfStudentEvent>(_onChangeSection);
  }
  FutureOr<void> _onEditProfile(
    UpdateProfileOfStudentEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    final result = await authRepository.updateStudentData(
      student: event.student,
      profilePhoto: event.profilePhoto,
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
}
