import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../models/class_session_with_flag.dart';
import '../repository/class_repository.dart';
import 'class_event.dart';
import 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassRepository classRepository;

  ClassBloc({required this.classRepository}) : super(ClassInitial()) {
    on<LoadTodayClassesEvent>(_onLoadTodayClasses);
  }

  Future<void> _onLoadTodayClasses(
      LoadTodayClassesEvent event,
      Emitter<ClassState> emit,
      ) async {
    emit(ClassLoading());

    await emit.forEach<Either<AppFailure, List<ClassSessionWithFlag>>>(
      classRepository.streamTodayClasses(event.sectionId, event.studentId),
      onData: (result) {
        return result.fold(
              (failure) => ClassError(message: failure.message),
              (classes) => TodayClassesLoaded(loadedClasses: classes),
        );
      },
      onError: (e, _) => ClassError(message: e.toString()),
    );
  }
}
