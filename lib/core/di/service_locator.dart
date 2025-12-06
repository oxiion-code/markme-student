import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:markme_student/features/attendance/bloc/my_attendance_bloc.dart';
import 'package:markme_student/features/attendance/repository/my_attendance_repository.dart';
import 'package:markme_student/features/attendance/repository/my_attendance_repository_impl.dart';
import 'package:markme_student/features/class/bloc/class_bloc.dart';
import 'package:markme_student/features/class/repository/class_repository.dart';
import 'package:markme_student/features/class/repository/class_repository_impl.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:markme_student/features/student/bloc/student_bloc.dart';
import 'package:markme_student/features/student/repositories/student_repository.dart';
import 'package:markme_student/features/student/repositories/student_repository_impl.dart';
import 'package:markme_student/features/time_table/bloc/time_table_bloc.dart';
import 'package:markme_student/features/time_table/repositories/time_table_repository.dart';
import 'package:markme_student/features/time_table/repositories/time_table_repository_impl.dart';

import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/repositories/auth_repository_impl.dart';

final sl=GetIt.instance;
 Future<void> init() async{
   sl.registerLazySingleton<FirebaseAuth>(()=>FirebaseAuth.instance);
   sl.registerLazySingleton<FirebaseFirestore>(()=>FirebaseFirestore.instance);
   sl.registerLazySingleton<FirebaseStorage>(()=>FirebaseStorage.instance);

   sl.registerLazySingleton<AuthRepository>(()=>AuthRepositoryImpl(sl(),sl(),sl()));
   sl.registerLazySingleton<StudentRepository>(()=>StudentRepositoryImpl(sl()));
   sl.registerLazySingleton<ClassRepository>(()=>ClassRepositoryImpl(sl()));
   sl.registerLazySingleton<MyAttendanceRepository>(()=>MyAttendanceRepositoryImpl(firestore: sl()));
   sl.registerLazySingleton<TimeTableRepository>(()=>TimeTableRepositoryImpl(firestore: sl(), storage: sl()));

   sl.registerFactory<AuthBloc>(()=>AuthBloc(sl()));
   sl.registerFactory<StudentBloc>(()=>StudentBloc(sl(),sl()));
   sl.registerFactory<ClassBloc>(()=>ClassBloc(classRepository: sl()));
   sl.registerFactory<MyAttendanceBloc>(()=>MyAttendanceBloc(attendanceRepository: sl()));
   sl.registerFactory<TimeTableBloc>(()=>TimeTableBloc(timeTableRepository: sl()));
   sl.registerFactory<EditProfileBloc>(()=>EditProfileBloc(authRepository: sl(),studentRepository: sl()));
 }