import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markme_student/core/error/failure.dart';
import 'package:markme_student/core/models/academic_batch.dart';
import 'package:markme_student/core/models/branch.dart';
import 'package:markme_student/core/models/course.dart';
import 'package:markme_student/features/student/models/student.dart';
import 'package:markme_student/features/student/repositories/student_repository.dart';

class StudentRepositoryImpl extends StudentRepository {
  FirebaseFirestore firestore;
  StudentRepositoryImpl(this.firestore);

  @override
  Future<Either<AppFailure, List<Course>>> getAllCourses() async {
    try {
      final snapshot = await firestore.collection('courses').get();
      final courses = snapshot.docs
          .map((course) => Course.fromMap(course.data()))
          .toList();
      return Right(courses);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<AcademicBatch>>> getBatchesByBranchId(
    String branchId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('academicBatches')
          .where('branchId', isEqualTo: branchId)
          .get();
      final batches = snapshot.docs
          .map((batch) => AcademicBatch.fromMap(batch.data()))
          .toList();
      return Right(batches);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Branch>>> getBranchesByCourseId(
    String courseId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('branches')
          .where('courseId', isEqualTo: courseId)
          .get();
      final branches = snapshot.docs
          .map((branch) => Branch.fromMap(branch.data()))
          .toList();
      return Right(branches);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<String>>> getSectionsByBatchId({
    required String batchId,
  }) async {
    try {
      final snapshot = await firestore
          .collection('sections')
          .where('batchId', isEqualTo: batchId)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Right([]);
      }
      final sectionIds = snapshot.docs.map((doc) => doc.id).toList();
      return Right(sectionIds);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Student>> getStudent(
      String? rollNo,
      String? registrationNo,
      ) async {
    try {
      final collection = FirebaseFirestore.instance.collection("students");
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (rollNo != null && rollNo.isNotEmpty) {
        snapshot = await collection.where("rollNo", isEqualTo: rollNo).get();
      } else if (registrationNo != null && registrationNo.isNotEmpty) {
        snapshot = await collection.where("registrationNo", isEqualTo: registrationNo).get();
      } else {
        return left(AppFailure(message: "Both rollNo and registrationNo are null"));
      }
      if (snapshot.docs.isEmpty) {
        return left(AppFailure(message: "Student not found"));
      }
      final student = Student.fromJson(snapshot.docs.first.data());
      return right(student);
    } catch (e) {
      return left(AppFailure(message: e.toString()));
    }
  }
  @override
  Future<Either<AppFailure, Unit>> deleteStudentCompletely(String uid) async {
    try {
      final auth = FirebaseAuth.instance;
      final collection = FirebaseFirestore.instance.collection("students");

      // 1. Delete Firestore student document
      await collection.doc(uid).delete();

      final currentUser = auth.currentUser;
      if (currentUser != null && currentUser.uid == uid) {
        await auth.signOut();
      }

      return right(unit); // success
    } catch (e) {
      return left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure,String>> updateStudentSection(
      String uid,
      String sectionId,
      ) async {
    try {
      final studentRef = firestore.collection("students").doc(uid);
      final studentSnap = await studentRef.get();
      if (!studentSnap.exists) {
        return Left(AppFailure(message: "Student not found"));
      }
      await studentRef.update({
        "sectionId": sectionId,
      });
      return Right(sectionId);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
