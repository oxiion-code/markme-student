import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/core/di/college_hive_service.dart';
import 'package:markme_student/core/theme/app_colors.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/student/models/student.dart';

import '../../student/models/student_cubit.dart';
class HomeSideBar extends StatelessWidget {
  const HomeSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final sidePadding = deviceWidth * 0.06;


    return Drawer(
      child: BlocBuilder<StudentCubit, Student?>(
        builder: (context, student) {
          if (student == null) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 28, horizontal: sidePadding),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryLight.withValues(alpha: 0.85),
                      AppColors.primaryLight.withValues(alpha: 0.7),
                      AppColors.primaryLight.withValues(alpha: 0.45),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 8),
                    Material(
                      elevation: 8,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: deviceHeight * 0.072,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: student.profilePhotoUrl,
                            height: deviceHeight * 0.145,
                            width: deviceWidth * 0.345,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => SizedBox(
                              height: 36,
                              width: 36,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: AppColors.primaryLight,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, size: 36),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      student.name ?? "Student Name",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        context.pop();
                        context.push("/editProfile", extra: student);
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              MaterialCommunityIcons.application_edit,
                              color: Colors.white,
                              size: 22,
                            ),
                            SizedBox(width: deviceWidth * 0.04),
                            Text(
                              "Edit profile",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(width: deviceWidth * 0.01),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sidePadding),
                child: Divider(color: AppColors.primaryLight.withOpacity(0.28)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sidePadding, vertical: 4),
                child: Column(
                  children: [
                    _drawerTile(
                      context,
                      leading: Icon(MaterialIcons.security, color: AppColors.primaryLight, size: 27),
                      title: "Profile Verification",
                      onTap: () {
                        Navigator.pop(context);
                        context.push( "/profile-verification", extra: student);
                      },
                    ),
                    _drawerTile(
                      context,
                      leading: Icon(MaterialIcons.device_hub, color: AppColors.primaryLight, size: 27),
                      title: "Opportunities Hub",
                      onTap: () {
                        Navigator.pop(context);
                        context.push( "/opportunities", extra: student);
                      },
                    ),
                    _drawerTile(
                      context,
                      leading: Icon(MaterialIcons.person_outline, color: AppColors.primaryLight, size: 27),
                      title: "My Attendance",
                      onTap: () {
                        Navigator.pop(context);
                        context.push("/myAttendance", extra: student);
                      },
                    ),
                    _drawerTile(
                      context,
                      leading: Icon(CupertinoIcons.clock, color: AppColors.primaryLight, size: 27),
                      title: "Time Table",
                      onTap: () {
                        Navigator.pop(context);
                        context.push("/timeTable", extra: student);
                      },
                    ),

                    _drawerTile(
                      context,
                      leading: Icon(CupertinoIcons.settings, color: AppColors.primaryLight, size: 27),
                      title: "Settings",
                      onTap: () {
                        Navigator.pop(context);
                        context.push("/settingScreen", extra: student);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _drawerTile(BuildContext context, {required Widget leading, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      hoverColor: AppColors.primaryLight.withOpacity(0.11),
      onTap: onTap,
      minLeadingWidth: 32,
      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}
