import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/core/di/college_hive_service.dart';

import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/primary_button.dart';
import '../../student/models/student_cubit.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              AppUtils.showCustomLoading(context);
            } else {
              context.pop();
            }

            if (state is UnAuthenticated) {
              // Not logged in → go to phone auth
              context.go( "/selectCollege");
            } else if (state is UserAlreadyLoggedIn) {
              context.read<StudentCubit>().setStudent(state.student!);
              context.go('/home', extra: state.student);
            } else if (state is ProfileIncomplete) {
              // Logged in but profile incomplete → go to Profile Update
              context.go('/studentRegistration', extra: state.student);
            } else if (state is AuthError) {
              AppUtils.showCustomSnackBar(context, state.error,isError: true);
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(flex: 1),
                  Image.asset(
                    "assets/images/app_icon_removed_bg.png",
                    height: height * 0.28,
                    width: width * 0.6,
                  ),
                  const Spacer(flex: 1),
                  Column(
                    children: [
                      Text(
                        "MarkMe",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "“Your seat is waiting, so is your future.”",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 2),
                  PrimaryButton(
                    text: "Continue →",
                    onPressed: () {
                      final college=CollegeHiveService.getCollege();
                      if(college==null){
                        context.go( "/selectCollege");
                      }else{
                        context.read<AuthBloc>().add(CheckAuthStatus(collegeId: college.id));
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
