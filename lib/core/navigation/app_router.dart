import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/core/di/college_hive_service.dart';
import 'package:markme_student/core/models/college_detail.dart';
import 'package:markme_student/features/attendance/bloc/my_attendance_bloc.dart';
import 'package:markme_student/features/attendance/screens/my_attendance_screen.dart';
import 'package:markme_student/features/auth/models/auth_info.dart';
import 'package:markme_student/features/auth/screens/select_college_screen.dart';
import 'package:markme_student/features/auth/screens/splash_screen.dart';
import 'package:markme_student/features/class/screens/live_class_detail_screen.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:markme_student/features/edit_profile/screens/edit_address_screen.dart';
import 'package:markme_student/features/edit_profile/screens/edit_parent_detail_screen.dart';
import 'package:markme_student/features/edit_profile/screens/edit_personal_details_screen.dart';
import 'package:markme_student/features/edit_profile/screens/section_detials_screen.dart';
import 'package:markme_student/features/edit_profile/screens/update_rollno_regno_screen.dart';
import 'package:markme_student/features/opportunities/bloc/opportunities_bloc.dart';
import 'package:markme_student/features/opportunities/models/placement_args.dart';
import 'package:markme_student/features/opportunities/screens/placement_registration_screen.dart';
import 'package:markme_student/features/opportunities/screens/placement_opportunities_screen.dart';
import 'package:markme_student/features/profile_verification/bloc/profile_verification_bloc.dart';
import 'package:markme_student/features/profile_verification/screens/document_verification_screen.dart';
import 'package:markme_student/features/profile_verification/screens/qualification_detail_screen.dart';
import 'package:markme_student/features/profile_verification/screens/profile_verification_screen.dart';
import 'package:markme_student/features/settings/screens/change_section_screen.dart';
import 'package:markme_student/features/settings/screens/devloper_details.dart';
import 'package:markme_student/features/settings/screens/setting_options_screen.dart';
import 'package:markme_student/features/student/bloc/student_bloc.dart';
import 'package:markme_student/features/student/models/student.dart';
import 'package:markme_student/features/edit_profile/screens/edit_profile_screen.dart';
import 'package:markme_student/features/student/models/student_cubit.dart';
import 'package:markme_student/features/time_table/bloc/time_table_bloc.dart';
import 'package:markme_student/features/time_table/screens/time_table_detail_screen.dart';

import '../../features/auth/screens/auth_otp_screen.dart';
import '../../features/auth/screens/auth_phone_no_screen.dart';
import '../../features/auth/screens/terms_and_condition.dart';
import '../../features/class/bloc/class_bloc.dart';
import '../../features/class/models/class_session.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/opportunities/screens/opportunities_hub_screen.dart';
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
      builder: (context, state) {
        final college = state.extra as CollegeDetail;
        return AuthPhoneNumberScreen(collegeDetail: college);
      },
    ),
    GoRoute(
      path: "/selectCollege",
      name: "select_college",
      builder: (context, state) => SelectCollegeScreen(),
    ),
    GoRoute(
      path: "/authOtp",
      name: "auth_otp",
      builder: (context, state) {
        final authInfo = state.extra as AuthInfo;
        return AuthOtpScreen(
          verificationId: authInfo.uid,
          phoneNumber: '+91${authInfo.phoneNumber}',
          collegeDetail: authInfo.collegeDetail!,
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
        final collegeId = CollegeHiveService.getCollege()!.id;
        return BlocProvider(
          create: (context) => sl<ClassBloc>(),
          child: HomeScreen(collegeId: collegeId, student: student),
        );
      },
    ),
    GoRoute(
      path: "/opportunities",
      builder: (context, state) {
        final student = state.extra as Student;
        return BlocProvider(
          create: (context) => OpportunitiesBloc(repository: sl()),
          child:OpportunitiesHubScreen(student: student),
        );
      },
    ),
    GoRoute(
      path: "/placements",
      builder: (context, state) {
        final student = state.extra as Student;
        return BlocProvider(
          create: (context) => OpportunitiesBloc(repository: sl()),
          child: PlacementOpportunitiesScreen(student: student),
        );
      },
    ),
    GoRoute(
      path: "/placement-details",
      builder: (context, state) {
        final placementArgs = state.extra as PlacementArgs;
        return BlocProvider(
          create: (context) => OpportunitiesBloc(repository: sl()),
          child: RegistrationForStudentScreen(
            student: placementArgs.student,
            placementSession: placementArgs.placementSession,
          ),
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
          create: (context) => EditProfileBloc(
            authRepository: sl(),
            studentRepository: sl(),
            editProfileRepository: sl(),
          ),
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
          create: (context) => EditProfileBloc(
            authRepository: sl(),
            studentRepository: sl(),
            editProfileRepository: sl(),
          ),
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
          create: (context) => EditProfileBloc(
            authRepository: sl(),
            studentRepository: sl(),
            editProfileRepository: sl(),
          ),
          child: EditAddressScreen(student: student),
        );
      },
    ),
    GoRoute(
      path: '/update-roll-reg-no',
      name: 'update_roll_reg_no',
      builder: (context, state) {
        final student = context.read<StudentCubit>().state;
        final collegeId = CollegeHiveService.getCollege()!.id;
        return BlocProvider(
          create: (context) => EditProfileBloc(
            authRepository: sl(),
            studentRepository: sl(),
            editProfileRepository: sl(),
          ),
          child: UpdateStudentRegOrRollNoScreen(
            collegeId: collegeId,
            student: student!,
          ),
        );
      },
    ),
    GoRoute(
      path: '/section-details',
      name: 'section_details',
      builder: (context, state) {
        final sectionId = state.extra as String;
        final collegeId = CollegeHiveService.getCollege()!.id;
        return BlocProvider(
          create: (context) => EditProfileBloc(
            authRepository: sl(),
            studentRepository: sl(),
            editProfileRepository: sl(),
          ),
          child: SectionDetailsScreen(collegeId: collegeId, sectionId: sectionId),
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
          create: (context) => EditProfileBloc(
            authRepository: sl(),
            studentRepository: sl(),
            editProfileRepository: sl(),
          ),
          child: ChangeSectionScreen(),
        );
      },
    ),
    GoRoute(
      path: "/document-verification",
      builder: (context, state) {
        final studentId = state.extra as String;
        return BlocProvider(
          create: (context) => ProfileVerificationBloc(repository: sl()),
          child: DocumentVerificationScreen(studentId: studentId),
        );
      },
    ),
    GoRoute(
      path: "/qualification-details",
      builder: (context, state) {
        final studentId = state.extra as String;
        return BlocProvider(
          create: (context) => ProfileVerificationBloc(repository: sl()),
          child: QualificationDetailsScreen(studentId: studentId),
        );
      },
    ),
    GoRoute(
      path: "/profile-verification",
      builder: (context, state) {
        final student = state.extra as Student;
        return BlocProvider(
          create: (context) => ProfileVerificationBloc(repository: sl()),
          child: ProfileVerificationScreen(student: student),
        );
      },
    ),
  ],
);
