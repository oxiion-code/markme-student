import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_student/features/class/models/class_session_with_flag.dart';
import 'package:markme_student/features/class/repository/class_repository.dart';
import '../../../core/error/failure.dart';
import '../models/class_session.dart';
class ClassRepositoryImpl extends ClassRepository {
  final FirebaseFirestore firestore;
  ClassRepositoryImpl(this.firestore);

  @override
  Stream<Either<AppFailure, List<ClassSessionWithFlag>>> streamTodayClasses(
      String sectionId,
      String studentId,
      ) async* {
    try {
      // 1️⃣ Fetch current semester number from section
      final sectionDoc =
      await firestore.collection("sections").doc(sectionId).get();

      if (!sectionDoc.exists) {
        yield Left(AppFailure(message: "Section not found"));
        return;
      }

      final sectionData = sectionDoc.data();
      if (sectionData == null || sectionData['currentSemesterNumber'] == null) {
        yield Left(AppFailure(message: "Semester number not found"));
        return;
      }

      final int currentSemesterNo = sectionData['currentSemesterNumber'];

      // 2️⃣ Stream classSessions of today with matching semesterNo
      final now = DateTime.now();
      final startOfDay =
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      final endOfDay = startOfDay + const Duration(days: 1).inMilliseconds;

      yield* firestore
          .collection("classSessions")
          .where("sectionId", isEqualTo: sectionId)
          .where("semesterNo", isEqualTo: currentSemesterNo)
          .where("date", isGreaterThanOrEqualTo: startOfDay)
          .where("date", isLessThan: endOfDay)
          .snapshots()
          .asyncMap((snapshot) async {
        try {
          final sessions = snapshot.docs
              .map((doc) => ClassSession.fromMap(doc.data()))
              .toList();

          // Collect attendanceIds
          final attendanceIds = sessions
              .map((s) => s.attendanceId)
              .where((id) => id != null && id.isNotEmpty)
              .toSet();

          // Fetch student attendance for each session
          final futures = attendanceIds.map((id) async {
            final recordDoc = await firestore
                .collection("attendance")
                .doc(id)
                .collection("records")
                .doc(studentId)
                .get();

            if (recordDoc.exists) {
              final data = recordDoc.data();
              return MapEntry(id!, data?['status'] == "present");
            }
            return MapEntry(id!, false);
          }).toList();

          final attendanceMap =
          Map<String, bool>.fromEntries(await Future.wait(futures));

          // Merge sessions with attendance info
          final results = sessions.map((session) {
            final attended = attendanceMap[session.attendanceId] ?? false;
            return ClassSessionWithFlag(
              classSession: session,
              isStudentPresent: attended,
            );
          }).toList();

          return Right<AppFailure, List<ClassSessionWithFlag>>(results);
        } catch (e) {
          return Left<AppFailure, List<ClassSessionWithFlag>>(
            AppFailure(message: e.toString()),
          );
        }
      });
    } catch (e) {
      yield Left(AppFailure(message: e.toString()));
    }
  }
}
