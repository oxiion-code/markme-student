import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_student/features/attendance/bloc/my_attendance_event.dart';
import 'package:markme_student/features/attendance/bloc/my_attendance_state.dart';
import 'package:markme_student/features/attendance/repository/my_attendance_repository.dart';

class MyAttendanceBloc extends Bloc<MyAttendanceEvent, MyAttendanceState> {
  final MyAttendanceRepository attendanceRepository;
  MyAttendanceBloc({required this.attendanceRepository})
    : super(MyAttendanceInitial()) {
    on<LoadMyAttendanceEvent>(_loadMyAttendance);
  }

  FutureOr<void> _loadMyAttendance(
    LoadMyAttendanceEvent event,
    Emitter<MyAttendanceState> emit,
  ) async {
    emit(MyAttendanceLoading());
    final result = await attendanceRepository.getSubjectWiseAttendance(
      event.studentId,
      event.sectionId,
    );
    result.fold(
      (failure) => emit(MyAttendanceError(failure.message)),
      (subjectWiseAttendance) => emit(
        MyAttendanceLoaded(subjectWiseAttendance: subjectWiseAttendance),
      ),
    );
  }
}
