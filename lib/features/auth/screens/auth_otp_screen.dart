import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/otp_boxes.dart';
import '../../student/models/student_cubit.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthOtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const AuthOtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  final TextEditingController otpController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return; // Safety check
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _resendOtp() {
    context.read<AuthBloc>().add(SendOtpEvent(widget.phoneNumber));
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (!mounted) return;

          // Show loading
          if (state is AuthLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            AppUtils.hideCustomLoading(context);
          }

          // OTP sent feedback
          if (state is OtpSent) {
            AppUtils.showCustomSnackBar(context, "OTP sent successfully",isError: false);
          }

          // Auth success
          if (state is AuthenticationSuccess) {
            if (state.isNewUser || state.student == null) {
              context.go('/studentRegistration', extra: state.student);
            } else {
              context.read<StudentCubit>().setStudent(state.student!);
              context.go('/home', extra: state.student);
            }
          }

          // Profile incomplete
          else if (state is ProfileIncomplete) {
            context.go('/studentRegistration', extra: state.student);
          }

          // Error
          else if (state is AuthError) {
            AppUtils.showCustomSnackBar(context, state.error,isError: true);
          }

          // Logout
          else if (state is LogoutSuccess) {
            context.goNamed('auth_phone');
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 80),
                    Lottie.asset(
                      "assets/animations/otp_animation.json",
                      height: 120,
                      width: 120,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "Please enter the OTP sent to your phone to complete verification.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OtpBoxes(controller: otpController),
                    const SizedBox(height: 16),
                    _canResend
                        ? TextButton(
                      onPressed: _resendOtp,
                      child: Text(
                        "Resend OTP",
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    )
                        : Text(
                      "Resend OTP in $_secondsRemaining sec",
                      style: TextStyle(color: AppColors.primaryDark),
                    ),
                  ],
                ),
                CustomButton(
                  onTap: () {
                    final otp = otpController.text.trim();
                    if (otp.length == 6) {
                      context.read<AuthBloc>().add(
                        VerifyOtpEvent(widget.verificationId, otp),
                      );
                    } else {
                      AppUtils.showCustomSnackBar(
                        context,
                        "Enter a valid 6 digit OTP",isError: true
                      );
                    }
                  },
                  text: "Verify OTP",
                  icon: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
