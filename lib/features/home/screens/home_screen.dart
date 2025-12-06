import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_student/features/class/bloc/class_bloc.dart';
import 'package:markme_student/features/class/bloc/class_state.dart';
import 'package:markme_student/features/home/widgets/home_bar.dart';
import 'package:markme_student/features/home/widgets/home_side_bar.dart';
import 'package:markme_student/features/student/models/student.dart';
import 'package:markme_student/features/class/models/class_session_with_flag.dart';
import '../../class/widgets/class_card.dart';
import '../../class/widgets/live_class_card.dart';
import '../../student/models/student_cubit.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    final deviceWidth = MediaQuery
        .of(context)
        .size
        .width;

    return BlocBuilder<StudentCubit, Student?>(
      builder: (context, student) {
        if (student == null) {
          return const Scaffold(
            body: Center(child: Text("Student is null")),
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: HomeAppBar(student: student), // reactive
          ),
          drawer: HomeSideBar(), // reactive
          body: BlocConsumer<ClassBloc, ClassState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ClassLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ClassError) {
                return Center(child: Text("Error: ${state.message}"));
              } else if (state is TodayClassesLoaded) {
                final classes = state.loadedClasses;
                final studentGroup = student.group;

                final liveClasses = classes
                    .where((c) {
                  final classGroup = c.classSession.group;
                  return classGroup == "All" || classGroup == studentGroup;
                })
                    .where((c) => c.classSession.status == "live")
                    .toList();
                final recentClasses = classes
                    .where((c) {
                  final classGroup = c.classSession.group;
                  return classGroup == "All" || classGroup == studentGroup;
                })
                    .where((c) => c.classSession.status != "live")
                    .toList();

                return _buildClassesUI(
                  context,
                  liveClasses,
                  recentClasses,
                  deviceHeight,
                  deviceWidth,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  Widget _buildClassesUI(BuildContext context,
      List<ClassSessionWithFlag> liveClasses,
      List<ClassSessionWithFlag> recentClasses,
      double deviceHeight,
      double deviceWidth,) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // College image
          Container(
            height: deviceHeight * 0.18,
            width: deviceWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/college_front.jpg"),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Live classes
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
                  .map((c) => LiveClassCard(classSession: c.classSession))
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Recent classes
          const Text(
            "Recent Classes",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Show recent classes or empty state
          if (recentClasses.isNotEmpty)
            Column(
              children: recentClasses
                  .map(
                    (c) =>
                    ClassCard(
                      subject: c.classSession.subjectName,
                      teacher: c.classSession.teacherName,
                      date: c.classSession.date.toString().split(" ")[0],
                      isPresent: c.isStudentPresent,
                    ),
              )
                  .toList(),
            )
          else
            SizedBox(
              height: deviceHeight * 0.3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.sentiment_satisfied_alt,
                      size: 80,
                      color: Colors.grey,
                    ),
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
            ),
        ],
      ),
    );
  }
}