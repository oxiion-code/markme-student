import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/student.dart';

class StudentCubit extends Cubit<Student?> {
  StudentCubit() : super(null);
  void setStudent(Student student) => emit(student); // set initial student
  void updateStudent(Student updated) => emit(updated); // update after edit
  void clearStudent() => emit(null); // logout
}
