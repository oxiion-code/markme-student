import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/features/attendance/bloc/my_attendance_bloc.dart';
import 'package:markme_student/features/attendance/screens/my_attendance_screen.dart';
import 'package:markme_student/features/auth/screens/splash_screen.dart';
import 'package:markme_student/features/class/screens/live_class_detail_screen.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:markme_student/features/edit_profile/screens/edit_address_screen.dart';
import 'package:markme_student/features/edit_profile/screens/edit_parent_detail_screen.dart';
import 'package:markme_student/features/edit_profile/screens/edit_personal_details_screen.dart';
import 'package:markme_student/features/settings/screens/change_section_screen.dart';
import 'package:markme_student/features/settings/screens/devloper_details.dart';
import 'package:markme_student/features/settings/screens/setting_options_screen.dart';
import 'package:markme_student/features/student/bloc/student_bloc.dart';
import 'package:markme_student/features/student/models/student.dart';
import 'package:markme_student/features/edit_profile/screens/edit_profile_screen.dart';
import 'package:markme_student/features/time_table/bloc/time_table_bloc.dart';
import 'package:markme_student/features/time_table/screens/time_table_detail_screen.dart';

import '../../features/auth/screens/auth_otp_screen.dart';
import '../../features/auth/screens/auth_phone_no_screen.dart';
import '../../features/auth/screens/terms_and_condition.dart';
import '../../features/class/bloc/class_bloc.dart';
import '../../features/class/bloc/class_event.dart';
import '../../features/class/models/class_session.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/student/screens/student_form_wizard.dart';
import '../di/service_locator.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash_screen',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/terms',
      builder: (context, state) => const TermsAndConditionsScreen(),
    ),
    GoRoute(
      path: "/authPhoneNumber",
      name: "auth_phone",
      builder: (context, state) => AuthPhoneNumberScreen(),
    ),
    GoRoute(
      path: "/authOtp",
      name: "auth_otp",
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final verificationId = args['verificationId'] as String;
        final phoneNumber = args['phoneNumber'] as String;
        return AuthOtpScreen(
          verificationId: verificationId,
          phoneNumber: '+91$phoneNumber',
        );
      },
    ),
    GoRoute(
      path: "/studentRegistration",
      name: 'student_registration',
      builder: (context, state) {
        final student = state.extra as Student;
        return BlocProvider(
          create: (context) => StudentBloc(sl(), sl()),
          child: StudentFormStepper(phoneNumber: student.phoneNumber),
        );
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) {
        final student = state.extra as Student;
        return BlocProvider(
          create: (context) => sl<ClassBloc>()
            ..add(
              LoadTodayClassesEvent(
                sectionId: student.sectionId,
                studentId: student.id,
              ),
            ),
          child: HomeScreen(),
        );
      },
    ),
    GoRoute(
      path: '/myAttendance',
      name: 'my_attendance',
      builder: (context, state) {
        final student = state.extra as Student;
        return BlocProvider(
          create: (context) => sl<MyAttendanceBloc>(),
          child: MyAttendanceScreen(student: student),
        );
      },
    ),
    GoRoute(
      path: '/timeTable',
      name: 'time_table',
      builder: (context, state) {
        final student = state.extra as Student;
        return BlocProvider(
          create: (context) => TimeTableBloc(timeTableRepository: sl()),
          child: TimeTableDetailScreen(student: student),
        );
      },
    ),
    GoRoute(
      path: '/editProfile',
      name: 'edit_profile',
      builder: (context, state) {
        return EditProfileOptionsScreen();
      },
    ),
    GoRoute(
      path: '/editPersonalDetail',
      name: 'edit_personal_detail',
      builder: (context, state) {
        final student = state.extra as Student;
        return BlocProvider(
          create: (context) =>
              EditProfileBloc(authRepository: sl(), studentRepository: sl()),
          child: EditPersonalDetailsScreen(student: student),
        );
      },
    ),
    GoRoute(
      path: '/editParentDetail',
      name: 'edit_parent_detail',
      builder: (context, state) {
        final student = state.extra as Student;
        return BlocProvider(
          create: (context) =>
              EditProfileBloc(authRepository: sl(), studentRepository: sl()),
          child: EditParentDetailsScreen(student: student),
        );
      },
    ),
    GoRoute(
      path: '/editAddressDetail',
      name: 'edit_address_detail',
      builder: (context, state) {
        final student = state.extra as Student;
        return BlocProvider(
          create: (context) =>
              EditProfileBloc(authRepository: sl(), studentRepository: sl()),
          child: EditAddressScreen(student: student),
        );
      },
    ),
    GoRoute(
      path: '/settingScreen',
      name: 'setting_screen',
      builder: (context, state) {
        return SettingOptionsScreen();
      },
    ),
    GoRoute(
      path: "/classDetails",
      builder: (context, state) {
        final ClassSession classSession = state.extra as ClassSession;
        return LiveClassDetailScreen(classSession: classSession);
      },
    ),
    GoRoute(
      path: "/developerDetails",
      builder: (context, state) {
        return DeveloperDetailsScreen();
      },
    ),
    GoRoute(
      path: "/changeSection",
      builder: (context, state) {
        return BlocProvider(
          create: (context) =>
              EditProfileBloc(authRepository: sl(), studentRepository: sl()),
          child: ChangeSectionScreen(),
        );
      },
    ),
  ],
);
