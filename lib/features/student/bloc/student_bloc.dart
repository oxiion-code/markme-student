import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_student/features/auth/repositories/auth_repository.dart';
import '../repositories/student_repository.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository studentRepository;
  final AuthRepository authRepository;

  StudentBloc(this.studentRepository, this.authRepository)
    : super(StudentInitial()) {
    on<GetAllCoursesEvent>(_onGetAllCourses);
    on<GetBatchesByBranchIdEvent>(_onGetBatchesByBranchId);
    on<GetBranchesByCourseIdEvent>(_onGetBranchesByCourseId);
    on<GetSectionsByBatchIdEvent>(_onGetSectionsByBatchId);
    on<RegisterStudentEvent>(_registerStudent);
  }

  Future<void> _onGetAllCourses(
    GetAllCoursesEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    final result = await studentRepository.getAllCourses(event.collegeId);
    result.fold(
      (failure) => emit(StudentError(failure.message)),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }

  Future<void> _onGetBatchesByBranchId(
    GetBatchesByBranchIdEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    final result = await studentRepository.getBatchesByBranchId(event.branchId,event.collegeId);
    result.fold(
      (failure) => emit(StudentError(failure.message)),
      (batches) => emit(BatchesLoaded(batches)),
    );
  }

  Future<void> _onGetBranchesByCourseId(
    GetBranchesByCourseIdEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    final result = await studentRepository.getBranchesByCourseId(
      event.courseId,
      event.collegeId
    );
    result.fold(
      (failure) => emit(StudentError(failure.message)),
      (branches) => emit(BranchesLoaded(branches)),
    );
  }

  Future<void> _onGetSectionsByBatchId(
    GetSectionsByBatchIdEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    final result = await studentRepository.getSectionsByBatchId(
      batchId: event.batchId,
      collegeId: event.collegeId
    );
    result.fold(
      (failure) => emit(StudentError(failure.message)),
      (sections) => emit(SectionsLoaded(sections)),
    );
  }
  FutureOr<void> _registerStudent(
      RegisterStudentEvent event,
      Emitter<StudentState> emit,
      ) async {
    emit(StudentRegistrationLoading());

    final isStudentExist = await studentRepository.getStudent(
      event.student.rollNo,
      event.student.regdNo,
      event.collegeId
    );

    if (isStudentExist.isLeft()) {
      // Student does NOT exist → Register new one
      final registerStudent = await authRepository.updateStudentData(
        profilePhoto: event.imageFile,
        student: event.student,
        collegeId: event.collegeId,
      );
      await registerStudent.fold(
            (failure){
          emit(StudentRegistrationError(failure.message));
        },
            (student) async {
          // ✅ AFTER successful registration → update seat allocation
          final seatResult = await studentRepository
              .updateSeatAllocationForStudent(
            event.collegeId,
            event.student.batchId,
          );
          seatResult.fold(
                (failure) {
              emit(StudentRegistrationError(
                "Student registered but seat allocation failed: ${failure.message}",
              ));
            },
                (_) {
              emit(StudentRegistered(student));
            },
          );
        },
      );
    }
    else {
      final student = isStudentExist.getOrElse(() => event.student);

      final deleteResult = await studentRepository.deleteStudentCompletely(
        student.id,
        event.collegeId
      );

      deleteResult.fold(
            (failure) => emit(
          StudentRegistrationError(
            "Student already exists, but failed to cleanup: ${failure.message}",
          ),
        ),
            (_) => emit(
          StudentRegistrationError(
            "Student with same credential already exists",
          ),
        ),
      );
    }
  }

}
