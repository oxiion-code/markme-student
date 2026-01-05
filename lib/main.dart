import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_student/core/navigation/app_router.dart';
import 'package:markme_student/core/theme/app_theme.dart';

import 'core/di/college_hive_service.dart';
import 'core/di/service_locator.dart' as di;
import 'core/models/college_detail.dart';
import 'core/models/college_schedule.dart';
import 'core/models/session_model.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/student/models/student_cubit.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(CollegeDetailAdapter());
  Hive.registerAdapter(CollegeScheduleAdapter());
  Hive.registerAdapter(SessionModelAdapter());
  await CollegeHiveService.init();

  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => StudentCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'student app',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
