import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_student/core/di/college_hive_service.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/attendance/bloc/my_attendance_bloc.dart';
import 'package:markme_student/features/attendance/bloc/my_attendance_event.dart';
import 'package:markme_student/features/attendance/bloc/my_attendance_state.dart';
import 'package:markme_student/features/attendance/models/subject_attendance.dart';
import 'package:markme_student/features/student/models/student.dart';
import 'package:intl/intl.dart';

class MyAttendanceScreen extends StatefulWidget {
  final Student student;
  const MyAttendanceScreen({super.key, required this.student});

  @override
  State<MyAttendanceScreen> createState() => _MyAttendanceScreenState();
}

class _MyAttendanceScreenState extends State<MyAttendanceScreen> {
  final collegeId= CollegeHiveService.getCollege()!.id;

  @override
  void initState() {
    super.initState();
    if(widget.student.sectionId.isNotEmpty){
      context.read<MyAttendanceBloc>().add(
        LoadMyAttendanceEvent(
            studentId: widget.student.id,
            sectionId: widget.student.sectionId,
            collegeId: collegeId
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          "My Attendance",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea( 
        child: BlocConsumer<MyAttendanceBloc, MyAttendanceState>(
          listener: (context, state) {
            if (state is MyAttendanceLoading) {
              AppUtils.showCustomLoading(context);
            } else {
              AppUtils.hideCustomLoading(context);
            }
          },
          builder: (context, state) {
            if (state is MyAttendanceLoaded) {
              final List<SubjectAttendance> subjectWiseAttendance = state.subjectWiseAttendance;

              if (subjectWiseAttendance.isEmpty) {
                return _buildEmptyState(theme);
              }

              // --- Calculate summary ---
              int theoryPresent = 0, theoryTotal = 0;
              int practicalPresent = 0, practicalTotal = 0;
              int overallPresent = 0, overallTotal = 0;

              for (var sub in subjectWiseAttendance) {
                overallPresent += sub.presentCount;
                overallTotal += sub.totalSessions;

                if (sub.subjectType.toLowerCase() == "theory") {
                  theoryPresent += sub.presentCount;
                  theoryTotal += sub.totalSessions;
                } else if (sub.subjectType.toLowerCase() == "practical") {
                  practicalPresent += sub.presentCount;
                  practicalTotal += sub.totalSessions;
                }
              }

              double overallPercent = overallTotal == 0 ? 0 : (overallPresent / overallTotal) * 100;
              double theoryPercent = theoryTotal == 0 ? 0 : (theoryPresent / theoryTotal) * 100;
              double practicalPercent = practicalTotal == 0 ? 0 : (practicalPresent / practicalTotal) * 100;

              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                children: [
                  _AttendanceSummaryCard(
                    overallPercent: overallPercent,
                    theoryPercent: theoryPercent,
                    practicalPercent: practicalPercent,
                  ),
                  const SizedBox(height: 12),
                  ...subjectWiseAttendance.map((subject) {
                    final double percentage = subject.totalSessions == 0
                        ? 0
                        : (subject.presentCount / subject.totalSessions) * 100;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Card(
                        elevation: 3,
                        color: Colors.white,
                        shadowColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          title: Text(
                            subject.subjectName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              _AnimatedProgressBar(percentage: percentage),
                              const SizedBox(width: 8),
                              Text(
                                "Present: ${subject.presentCount}/${subject.totalSessions} (${percentage.toStringAsFixed(1)}%)",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: percentage < 75
                                      ? Colors.red.shade700
                                      : Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          trailing: CircleAvatar(
                            backgroundColor: percentage < 75
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                            radius: 24,
                            child: Text(
                              "${percentage.toStringAsFixed(0)}%",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: percentage < 75
                                    ? Colors.red
                                    : Colors.green.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: Text(
                                "Sessions",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            Divider(thickness: 1.2, color: Colors.grey.shade300),
                            ...subject.sessions.map((session) {
                              final isPresent = session.isPresent == "present";
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                child: ListTile(
                                  leading: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: isPresent
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isPresent
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      isPresent ? Icons.check_rounded : Icons.close_rounded,
                                      color: isPresent
                                          ? Colors.green.shade600
                                          : Colors.red.shade600,
                                      size: 24,
                                    ),
                                  ),
                                  title: Text(
                                    "Class #${session.srNo}",
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _formatDate(session.dateAndTime),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  trailing: _StatusPill(isPresent: isPresent),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            }

            if (state is MyAttendanceError) {
              return Center(
                child: Text(
                  state.message,
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              );
            }
            if(widget.student.sectionId.isEmpty){
              final deviceHeight = MediaQuery.of(context).size.height;
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
            return const Center(child: Text(""));
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy, size: 56, color: Colors.blueGrey.shade200),
          const SizedBox(height: 12),
          Text(
            "No attendance data found",
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.blueGrey.shade500),
          ),
          Text(
            "Try checking after upcoming sessions.",
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    try {
      return DateFormat("dd MMM yyyy • hh:mm a").format(dateTime);
    } catch (e) {
      return dateTime.toString();
    }
  }
}

class _AttendanceSummaryCard extends StatelessWidget {
  final double overallPercent;
  final double theoryPercent;
  final double practicalPercent;

  const _AttendanceSummaryCard({
    required this.overallPercent,
    required this.theoryPercent,
    required this.practicalPercent,
  });

  Color _getColor(double percent) {
    if (percent < 50) return Colors.red;
    if (percent < 75) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.blue.shade50,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Summary",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                )),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPercentBox("Overall", overallPercent),
                _buildPercentBox("Theory", theoryPercent),
                _buildPercentBox("Practical", practicalPercent),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPercentBox(String label, double percent) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: _getColor(percent).withOpacity(0.2),
          child: Text(
            "${percent.toStringAsFixed(0)}%",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getColor(percent),
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            )),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isPresent;
  const _StatusPill({required this.isPresent});

  @override
  Widget build(BuildContext context) {
    final bgColor = isPresent ? Colors.green.shade50 : Colors.red.shade50;
    final textColor = isPresent ? Colors.green.shade700 : Colors.red.shade700;
    final label = isPresent ? "Present" : "Absent";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isPresent ? Colors.green.shade300 : Colors.red.shade300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _AnimatedProgressBar extends StatelessWidget {
  final double percentage;
  const _AnimatedProgressBar({required this.percentage});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (percentage < 50) {
      color = Colors.red;
    } else if (percentage < 75) {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }
    return SizedBox(
      width: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LinearProgressIndicator(
          value: percentage / 100,
          minHeight: 7,
          color: color,
          backgroundColor: Colors.grey.shade200,
        ),
      ),
    );
  }
}
