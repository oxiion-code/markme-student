import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_student/features/time_table/bloc/time_table_event.dart';
import 'package:markme_student/features/time_table/bloc/time_table_state.dart';

import '../models/time_table.dart';
import '../repositories/time_table_repository.dart';





class TimeTableBloc extends Bloc<TimeTableEvent, TimeTableState> {
  final TimeTableRepository timeTableRepository;

  TimeTableBloc({required this.timeTableRepository})
      : super(TimeTableInitial()) {
    on<FetchTimeTableForStudentEvent>(_fetchTimeTableForStudent);
  }

  FutureOr<void> _fetchTimeTableForStudent(
      FetchTimeTableForStudentEvent event,
      Emitter<TimeTableState> emit,
      ) async {
    emit(TimeTableLoading());

    final result = await timeTableRepository.fetchTimeTableForStudent(event.sectionId ,event.collegeId);

    result.fold(
          (failure) => emit(TimeTableError(message: failure.message)),
          (timeTable) => emit(StudentTimeTableLoaded(timeTable: timeTable)),
    );
  }
}
