import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/core/di/college_hive_service.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/profile_verification/bloc/profile_verification_bloc.dart';
import 'package:markme_student/features/profile_verification/bloc/profile_verification_event.dart';
import 'package:markme_student/features/profile_verification/bloc/profile_verification_state.dart';
import 'package:markme_student/features/student/models/student.dart';

import '../../student/models/student_cubit.dart';

class ProfileVerificationScreen extends StatefulWidget {
  final Student student;
  const ProfileVerificationScreen({super.key, required this.student});

  @override
  State<ProfileVerificationScreen> createState() =>
      _ProfileVerificationScreenState();
}

class _ProfileVerificationScreenState extends State<ProfileVerificationScreen> {
  final collegeId = CollegeHiveService.getCollege()!.id;
  String profileVerificationStatus = "no_data";
  @override
  void initState() {
    super.initState();
    context.read<ProfileVerificationBloc>().add(
      CheckAccountVerificationStatus(
        collegeId: collegeId,
        studentId: widget.student.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ProfileVerificationBloc, ProfileVerificationState>(
      listener: (context, state) {
        if (state is ProfileVerificationLoading) {
          AppUtils.showCustomLoading(context);
        } else {
          AppUtils.hideCustomLoading(context);
        }
        if (state is ProfileVerificationStatusLoaded) {
          final studentCubit = context.read<StudentCubit>();
          final currentStudent = studentCubit.state;
          if (currentStudent != null) {
            studentCubit.updateStudent(
              currentStudent.copyWith(
                isProfileVerified: state.status, // e.g. 'both_uploaded'
              ),
            );
          }
          setState(() {
            profileVerificationStatus = state.status;
          });
        } else if (state is ProfileVerificationError) {
          AppUtils.showCustomSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Verification'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Complete your profile verification',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _VerificationOptionCard(
                  icon: Icons.verified_user,
                  title: 'Document Verification',
                  subtitle: 'Upload and verify your identity documents',
                  onTap: () {
                    if (profileVerificationStatus == "verified") {
                      AppUtils.showCustomSnackBar(
                        context,
                        "Documents are already verified",
                      );
                    } else if (profileVerificationStatus == "both_uploaded") {
                      AppUtils.showCustomSnackBar(
                        context,
                        "Documents are uploaded but not verified yet",
                      );
                    } else if(profileVerificationStatus == "d_uploaded" ){
                      AppUtils.showCustomSnackBar(
                        context,
                        "Provide qualification details to start verification",isError: true
                      );
                    }else {
                      context
                          .push(
                            '/document-verification',
                            extra: widget.student.id,
                          )
                          .then((response) {
                            if (response == "uploaded") {
                              context.read<ProfileVerificationBloc>().add(
                                CheckAccountVerificationStatus(
                                  collegeId: collegeId,
                                  studentId: widget.student.id,
                                ),
                              );
                            }
                          });
                    }
                  },
                ),
                const SizedBox(height: 12),
                _VerificationOptionCard(
                  icon: Icons.school,
                  title: 'Qualification Details',
                  subtitle: 'Give complete academic qualification details',
                  onTap: () {
                    if (profileVerificationStatus == "verified") {
                      AppUtils.showCustomSnackBar(
                        context,
                        "Qualification details are already verified",
                      );
                    } else if (profileVerificationStatus == "e_uploaded" ||
                        profileVerificationStatus == "both_uploaded") {
                      AppUtils.showCustomSnackBar(
                        context,
                        "Qualification details are uploaded but not verified yet",
                      );
                    } else if (profileVerificationStatus == "d_uploaded") {
                      context
                          .push(
                            "/qualification-details",
                            extra: widget.student.id,
                          )
                          .then((response) {
                            if (response == "uploaded") {
                              context.read<ProfileVerificationBloc>().add(
                                CheckAccountVerificationStatus(
                                  collegeId: collegeId,
                                  studentId: widget.student.id,
                                ),
                              );
                            }
                          });
                    } else {
                      AppUtils.showCustomSnackBar(
                        context,
                        "Upload the documents first",
                        isError: true,
                      );
                    }
                  },
                ),
                const SizedBox(height: 18),
                if(profileVerificationStatus=="verified")...[
                  Card(
                    color: Colors.green.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.green.shade300),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your account is already verified \nFor any changes contact admin',
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
                if(profileVerificationStatus=="both_uploaded")...[
                  Card(
                    color: Colors.orange.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.yellow.shade300),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.brown.shade700,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your profile verification is currently in progress.\nPlease contact the admin for any changes.',
                              style: TextStyle(
                                color: Colors.yellow.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
                if(profileVerificationStatus.contains("failed"))...[
                  Card(
                    color: Colors.orange.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.yellow.shade300),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.brown.shade700,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "$profileVerificationStatus. Upload all the information again and apply for reverification within 4 days.",
                              style: TextStyle(
                                color: Colors.yellow.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VerificationOptionCard extends StatelessWidget {
  const _VerificationOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(icon, color: colorScheme.onPrimaryContainer),
            ),
            title: Text(title, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
