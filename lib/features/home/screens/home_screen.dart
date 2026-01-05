import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:markme_student/core/di/college_hive_service.dart';

import 'package:markme_student/features/class/bloc/class_bloc.dart';
import 'package:markme_student/features/class/bloc/class_event.dart';
import 'package:markme_student/features/class/bloc/class_state.dart';

import 'package:markme_student/features/home/widgets/home_bar.dart';
import 'package:markme_student/features/home/widgets/home_side_bar.dart';

import 'package:markme_student/features/student/models/student.dart';
import 'package:markme_student/features/student/models/student_cubit.dart';

import 'package:markme_student/features/class/models/class_session_with_flag.dart';
import 'package:markme_student/features/class/widgets/class_card.dart';
import 'package:markme_student/features/class/widgets/live_class_card.dart';

class HomeScreen extends StatefulWidget {
  final String collegeId;
  final Student student;

  const HomeScreen({
    super.key,
    required this.collegeId,
    required this.student,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final String _collegeBanner =
  CollegeHiveService.getCollege()!.bannerLink!;

  @override
  void initState() {
    super.initState();
    if (widget.student.sectionId.isNotEmpty) {
      context.read<ClassBloc>().add(
        LoadTodayClassesEvent(
          sectionId: widget.student.sectionId,
          studentId: widget.student.id,
          collegeId: widget.collegeId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<StudentCubit, Student?>(
      builder: (context, student) {
        if (student == null) {
          return const Scaffold(
            body: Center(child: Text("Student data not available")),
          );
        }
        if (student.sectionId.isEmpty) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: HomeAppBar(student: student),
            ),
            drawer: const HomeSideBar(),
            body: Column(
              children: [
                _collegeBannerWidget(deviceHeight, deviceWidth),
                _buildSectionNotAllottedUI(deviceHeight),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: HomeAppBar(student: student),
          ),
          drawer: const HomeSideBar(),
          body: BlocConsumer<ClassBloc, ClassState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ClassLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ClassError) {
                return Center(child: Text("Error: ${state.message}"));
              }

              if (state is TodayClassesLoaded) {
                return _buildClassesUI(
                  student: student,
                  classes: state.loadedClasses,
                  deviceHeight: deviceHeight,
                  deviceWidth: deviceWidth,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  // ===================== UI BUILDERS =====================

  /// ✅ College banner with shimmer
  Widget _collegeBannerWidget(double deviceHeight, double deviceWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          height: deviceHeight * 0.18,
          width: deviceWidth,
          child: CachedNetworkImage(
            imageUrl: _collegeBanner,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(color: Colors.white),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassesUI({
    required Student student,
    required List<ClassSessionWithFlag> classes,
    required double deviceHeight,
    required double deviceWidth,
  }) {
    final studentGroup = student.group;

    final liveClasses = classes
        .where((c) =>
    (c.classSession.group == "All" ||
        c.classSession.group == studentGroup) &&
        c.classSession.status == "live")
        .toList();

    final recentClasses = classes
        .where((c) =>
    (c.classSession.group == "All" ||
        c.classSession.group == studentGroup) &&
        c.classSession.status != "live")
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _collegeBannerWidget(deviceHeight, deviceWidth),
          const SizedBox(height: 20),

          /// Live Classes
          if (liveClasses.isNotEmpty) ...[
            const Text(
              "Live Classes 🔴",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: liveClasses
                  .map((c) =>
                  LiveClassCard(classSession: c.classSession))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],

          /// Recent Classes
          const Text(
            "Recent Classes",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          if (recentClasses.isNotEmpty)
            Column(
              children: recentClasses
                  .map(
                    (c) => ClassCard(
                  subject: c.classSession.subjectName,
                  teacher: c.classSession.teacherName,
                  date: c.classSession.date
                      .toString()
                      .split(" ")
                      .first,
                  isPresent: c.isStudentPresent,
                ),
              )
                  .toList(),
            )
          else
            _buildEmptyRecentClasses(deviceHeight),
        ],
      ),
    );
  }

  Widget _buildEmptyRecentClasses(double deviceHeight) {
    return SizedBox(
      height: deviceHeight * 0.3,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_satisfied_alt,
                size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No recent classes",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionNotAllottedUI(double deviceHeight) {
    return SizedBox(
      height: deviceHeight * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_outlined,
                size: 80, color: Colors.orange),
            const SizedBox(height: 24),
            const Text(
              "Data Not Verified Yet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Your data is not verified yet and section is not allotted. Please contact your administrator.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
