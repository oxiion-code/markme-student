import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../student/models/student.dart';

import '../bloc/time_table_bloc.dart';
import '../bloc/time_table_event.dart';
import '../bloc/time_table_state.dart';

class TimeTableDetailScreen extends StatefulWidget {
  final Student student; // Pass the student instead of timetable
  const TimeTableDetailScreen({super.key, required this.student});

  @override
  State<TimeTableDetailScreen> createState() => _TimeTableDetailScreenState();
}

class _TimeTableDetailScreenState extends State<TimeTableDetailScreen> {
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Trigger the fetch when the screen is initialized
    context.read<TimeTableBloc>().add(
      FetchTimeTableForStudentEvent(sectionId: widget.student.sectionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Student Timetable",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 2,
        backgroundColor: Colors.blue.shade50,
      ),
      body: BlocBuilder<TimeTableBloc, TimeTableState>(
        builder: (context, state) {
          if (state is TimeTableLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudentTimeTableLoaded) {
            final timetable = state.timeTable;

            return Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.book, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              timetable.courseName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Uploaded on: ${timetable.uploadedAt.toLocal().toString().split(' ')[0].split('-').reversed.join('/ ')}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.school, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              "Semester: ${timetable.semesterName.toUpperCase() ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // PDF Viewer
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: timetable.pdfUrl.isNotEmpty
                        ? timetable.pdfUrl.startsWith('http')
                              ? SfPdfViewer.network(
                                  timetable.pdfUrl,
                                  key: pdfViewerKey,
                                  enableDoubleTapZooming: true,
                                  enableTextSelection: true,
                                  canShowScrollHead: true,
                                  canShowScrollStatus: true,
                                  scrollDirection: PdfScrollDirection.vertical,
                                )
                              : SfPdfViewer.file(
                                  File(timetable.pdfUrl),
                                  key: pdfViewerKey,
                                  enableDoubleTapZooming: true,
                                  enableTextSelection: true,
                                  canShowScrollHead: true,
                                  canShowScrollStatus: true,
                                  scrollDirection: PdfScrollDirection.vertical,
                                )
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.picture_as_pdf,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "No PDF available",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            );
          } else if (state is TimeTableError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
