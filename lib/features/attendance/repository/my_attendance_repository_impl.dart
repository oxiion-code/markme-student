import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_student/core/error/failure.dart';
import 'package:markme_student/features/attendance/models/session.dart';
import 'package:markme_student/features/attendance/models/subject_attendance.dart';
import 'package:markme_student/features/attendance/repository/my_attendance_repository.dart';

class MyAttendanceRepositoryImpl extends MyAttendanceRepository {
  final FirebaseFirestore firestore;
  MyAttendanceRepositoryImpl({required this.firestore});

  @override
  Future<Either<AppFailure, List<SubjectAttendance>>> getSubjectWiseAttendance(
    String studentId,
    String sectionId,
    String collegeId,
  ) async {
    try {
      // Get section document
      final sectionDoc = await firestore
          .collection("sections")
          .doc(collegeId)
          .collection("sections")
          .doc(sectionId)
          .get();
      if (!sectionDoc.exists) {
        return Left(AppFailure(message: "Section not found"));
      }

      final sectionData = sectionDoc.data();
      if (sectionData == null || sectionData['currentSemesterNumber'] == null) {
        return Left(AppFailure(message: "Semester number not found"));
      }
      final int currentSemesterNo = sectionData['currentSemesterNumber'];

      // Fetch all attendance docs for the current semester

      final attendanceSnapshot = await firestore
          .collection("attendance")
          .doc(collegeId)
          .collection("attendance")
          .where("sectionId", isEqualTo: sectionId)
          .where("semesterNo", isEqualTo: currentSemesterNo)
          .get();

      // Prepare futures to fetch student records in parallel
      final List<Future<Map<String, dynamic>>> recordFutures =
          attendanceSnapshot.docs.map((attendanceDoc) async {
            final attData = attendanceDoc.data();
            final recordSnap = await firestore
                .collection("attendance").doc(collegeId).collection("attendance")
                .doc(attendanceDoc.id)
                .collection("records")
                .where("studentId", isEqualTo: studentId)
                .get();

            return {'attendanceDoc': attData, 'records': recordSnap};
          }).toList();

      final allResults = await Future.wait(recordFutures);

      // Collect sessions per subject
      final Map<String, List<Session>> subjectSessions = {};
      final Set<String> subjectIds = {};

      for (var res in allResults) {
        final attData = res['attendanceDoc'] as Map<String, dynamic>;
        final snap = res['records'] as QuerySnapshot;

        final subjectId = attData['subjectId'] as String;
        subjectIds.add(subjectId);

        for (var record in snap.docs) {
          final data = record.data() as Map<String, dynamic>;
          DateTime dateTime = (data['timestamp'] is Timestamp)
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.now();

          final session = Session(
            srNo: (subjectSessions[subjectId]?.length ?? 0) + 1,
            dateAndTime: dateTime,
            isPresent: (data['status'] ?? "absent") as String,
          );

          subjectSessions.putIfAbsent(subjectId, () => []);
          subjectSessions[subjectId]!.add(session);
        }
      }
      if (subjectIds.isEmpty) {
        return const Right([]);
      }
      // Batch fetch subject names and types
      final subjectDocs = await firestore
          .collection("subjects").doc(collegeId).collection("subjects")
          .where(FieldPath.documentId, whereIn: subjectIds.toList())
          .get();

      final Map<String, String> subjectNames = {};
      final Map<String, String> subjectTypes = {};

      for (var doc in subjectDocs.docs) {
        final data = doc.data();
        subjectNames[doc.id] = data['subjectName'] ?? "Unknown";
        subjectTypes[doc.id] = data['subjectType'] ?? "Theory";
      }

      // Build final SubjectAttendance list
      final List<SubjectAttendance> result = subjectSessions.entries.map((
        entry,
      ) {
        final subjectId = entry.key;
        final sessions = entry.value;
        final presentCount = sessions
            .where((s) => s.isPresent.toLowerCase() == "present")
            .length;

        return SubjectAttendance(
          subjectId: subjectId,
          subjectName: subjectNames[subjectId] ?? "Unknown",
          sessions: sessions,
          totalSessions: sessions.length,
          presentCount: presentCount,
          subjectType: subjectTypes[subjectId] ?? "Theory",
        );
      }).toList();

      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
