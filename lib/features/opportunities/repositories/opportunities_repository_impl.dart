import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_student/core/error/failure.dart';
import 'package:markme_student/features/opportunities/models/placement_form.dart';
import 'package:markme_student/features/opportunities/models/placement_session.dart';
import 'package:markme_student/features/opportunities/repositories/opportunities_repository.dart';
import 'package:markme_student/features/profile_verification/models/qualification.dart';

import '../models/student_application.dart';

class OpportunitiesRepositoryImpl extends OpportunitiesRepository {
  final FirebaseFirestore firestore;
  OpportunitiesRepositoryImpl({required this.firestore});
  @override
  Future<Either<AppFailure, List<PlacementSession>>> loadPlacementSessions(
    String collegeId,
    String batchId,
  ) async {
    try {
      final querySnapshot = await firestore
          .collection('placement')
          .doc(collegeId)
          .collection('sessions')
          .where('driveType', isEqualTo: 'Placement')
          .where('status', isEqualTo: 'live')
          .where('eligibility.batches', arrayContains: batchId)
          .orderBy('createdAt', descending: true)
          .get();

      final sessions = querySnapshot.docs.map((doc) {
        return PlacementSession.fromJson(doc.data());
      }).toList();

      return Right(sessions);
    } catch (e) {
      return Left(AppFailure(message: 'Failed to load placement sessions'));
    }
  }

  @override
  Future<Either<AppFailure, List<Qualification>>> loadStudentQualifications(
    String collegeId,
    String studentId,
  ) async {
    try {
      final snapshot = await firestore
          .collection("students")
          .doc(collegeId)
          .collection("students")
          .doc(studentId)
          .collection("qualification_details")
          .get();
      final qualifications = snapshot.docs
          .map((q) => Qualification.fromMap(q.data()!))
          .toList();
      return Right(qualifications);
    } catch (e) {
      return left(AppFailure(message: e.toString()));
    }
  }
  @override
  Future<Either<AppFailure, Unit>> submitPlacementApplication({
    required String collegeId,
    required String sessionId,
    required String studentId,
    required PlacementForm form,
  }) async {
    try {
      final applicationId = '${sessionId}_$studentId';

      final mainAppRef = firestore
          .collection('placement')
          .doc(collegeId)
          .collection('sessions')
          .doc(sessionId)
          .collection('applications')
          .doc(applicationId);

      final studentDocRef = firestore
          .collection('student_applications')
          .doc(studentId);

      final studentAppRef = studentDocRef
          .collection('applications')
          .doc(sessionId);

      return await firestore.runTransaction((txn) async {
        /// 🚫 Prevent duplicate apply (same session)
        final existingApp = await txn.get(mainAppRef);
        if (existingApp.exists) {
          throw AppFailure(
            message: 'You have already applied for this position.',
          );
        }

        /// 🔢 Get student application count
        final studentSnap = await txn.get(studentDocRef);
        int appliedCount = 0;

        if (studentSnap.exists) {
          appliedCount =
          (studentSnap.data()?['appliedPlacementApplications'] ?? 0) as int;
        }

        /// 🚫 Max limit reached
        if (appliedCount >= 2) {
          throw AppFailure(
            message: 'You can apply for only 2 placement sessions.',
          );
        }

        /// ✅ Main application
        txn.set(mainAppRef, form.toMap());

        /// ✅ Student application entry
        final studentApp = StudentApplication(
          applicationId: applicationId,
          sessionId: sessionId,
          companyId: form.companyId!,
          companyName: form.companyName!,
          jobTitle: form.jobTitle!,
          status: 'applied',
          appliedAt: DateTime.now().toIso8601String(),
        );
        txn.set(studentAppRef, studentApp.toMap());

        /// ✅ Update / create counter
        txn.set(
          studentDocRef,
          {
            'appliedPlacementApplications': appliedCount + 1,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true), // creates if not exists
        );
        return Right(unit);
      });
    } on AppFailure catch (e) {
      return Left(e);
    } on FirebaseException catch (e) {
      return Left(
        AppFailure(message: e.message ?? 'Firebase error occurred.'),
      );
    } catch (e) {
      return Left(
        AppFailure(message: e.toString()),
      );
    }
  }
  @override
  Future<Either<AppFailure, List<StudentApplication>>>
  getStudentApplications(String studentId) async {
    try {
      final snapshot = await firestore
          .collection('student_applications')
          .doc(studentId)
          .collection('applications')
          .orderBy('appliedAt', descending: true)
          .get();

      final applications = snapshot.docs
          .map((doc) => StudentApplication.fromMap(doc.data()))
          .toList();

      return Right(applications);
    } on FirebaseException catch (e) {
      return Left(
        AppFailure(message: e.message ?? 'Failed to load applications'),
      );
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
  @override
  Future<Either<AppFailure, Unit>> deleteStudentApplication({
    required String collegeId,
    required String sessionId,
    required String studentId,
  }) async {
    try {
      final applicationId = '${sessionId}_$studentId';

      final mainAppRef = firestore
          .collection('placement')
          .doc(collegeId)
          .collection('sessions')
          .doc(sessionId)
          .collection('applications')
          .doc(applicationId);

      final studentDocRef = firestore
          .collection('student_applications')
          .doc(studentId);

      final studentAppRef = studentDocRef
          .collection('applications')
          .doc(sessionId);

      await firestore.runTransaction((txn) async {
        final appSnap = await txn.get(studentAppRef);

        if (!appSnap.exists) {
          throw AppFailure(message: 'Application not found.');
        }

        final appliedAtStr = appSnap.data()?['appliedAt'] as String?;
        if (appliedAtStr == null) {
          throw AppFailure(message: 'Invalid application data.');
        }

        /// ✅ FORCE UTC COMPARISON
        final appliedAt = DateTime.parse(appliedAtStr).toUtc();
        final now = DateTime.now().toUtc();

        final duration = now.difference(appliedAt);

        /// 🚫 STRICT 2-HOUR RULE
        if (duration >= const Duration(hours: 2)) {
          throw AppFailure(
            message: 'Withdrawal allowed only within 2 hours of applying.',
          );
        }

        /// 🔢 Read student counter
        final studentSnap = await txn.get(studentDocRef);
        int appliedCount = 0;

        if (studentSnap.exists) {
          appliedCount =
          (studentSnap.data()?['appliedPlacementApplications'] ?? 0) as int;
        }

        /// ❌ Decrement safely
        if (appliedCount > 0) {
          txn.update(studentDocRef, {
            'appliedPlacementApplications': appliedCount - 1,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        /// ❌ Delete application docs
        txn.delete(mainAppRef);
        txn.delete(studentAppRef);
      });

      return const Right(unit);
    } on AppFailure catch (e) {
      return Left(e);
    } on FirebaseException catch (e) {
      return Left(
        AppFailure(message: e.message ?? 'Failed to withdraw application'),
      );
    } catch (e) {
      return Left(
        AppFailure(message: e.toString()),
      );
    }
  }

}

