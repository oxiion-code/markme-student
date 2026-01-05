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
  Future<Either<AppFailure, List<Course>>> getAllCourses(
    String collegeId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('courses')
          .doc(collegeId)
          .collection('courses')
          .get();
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
    String collegeId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('academicBatches')
          .doc(collegeId)
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
    String collegeId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('branches')
          .doc(collegeId)
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
    required String collegeId,
  }) async {
    try {
      final snapshot = await firestore
          .collection('sections')
          .doc(collegeId)
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
    String collegeId,
  ) async {
    try {
      final collection = firestore
          .collection("students")
          .doc(collegeId)
          .collection("students");
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (rollNo != null && rollNo.isNotEmpty) {
        snapshot = await collection.where("rollNo", isEqualTo: rollNo).get();
      } else if (registrationNo != null && registrationNo.isNotEmpty) {
        snapshot = await collection
            .where("registrationNo", isEqualTo: registrationNo)
            .get();
      } else {
        return left(
          AppFailure(message: "Both rollNo and registrationNo are null"),
        );
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
  Future<Either<AppFailure, Unit>> deleteStudentCompletely(
    String uid,
    String collegeId,
  ) async {
    try {
      final auth = FirebaseAuth.instance;
      final collection = FirebaseFirestore.instance
          .collection("students")
          .doc(collegeId)
          .collection("students");

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
  Future<Either<AppFailure, String>> updateStudentSection(
      String studentId,
      String sectionId,
      String collegeId,
      ) async {
    try {
      final studentRef = firestore
          .collection("students")
          .doc(collegeId)
          .collection("students")
          .doc(studentId);

      final permissionRef =
      studentRef.collection("permissions").doc("main");

      /// 1️⃣ Ensure student exists
      final studentSnap = await studentRef.get();
      if (!studentSnap.exists) {
        return Left(AppFailure(message: "Student not found"));
      }

      /// 2️⃣ Read permission doc (safe even if missing)
      final permissionSnap = await permissionRef.get();
      final permissionData = permissionSnap.data() ?? {};

      /// 3️⃣ Extract permission safely
      final bool canChangeSection =
          permissionData["canChangeSection"] == true;

      /// 4️⃣ If permission denied or missing → deny + ensure field exists
      if (!canChangeSection) {
        await permissionRef.set(
          {"canChangeSection": false},
          SetOptions(merge: true),
        );

        return Left(
          AppFailure(message: "Section change not permitted"),
        );
      }

      /// 5️⃣ Permission allowed → update section
      await studentRef.update({
        "sectionId": sectionId,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      return Right(sectionId);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }



  @override
  Future<Either<AppFailure, Unit>> updateSeatAllocationForStudent(
      String collegeId,
      String batchId,
      ) async {
    try {
      final batchDetails = batchId.split("_");
      final seatAllocationId = "${batchDetails[0]}_${batchDetails[1]}";
      final docRef = FirebaseFirestore.instance
          .collection('seat_allocation')
          .doc(collegeId)
          .collection('seat_allocation')
          .doc(seatAllocationId);

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception("Seat allocation document not found");
        }

        final currentSeats = snapshot.get('availableSeats') as int;

        if (currentSeats <= 0) {
          throw Exception("No seats available");
        }

        transaction.update(docRef, {
          'availableSeats': FieldValue.increment(-1),
        });
      });
      return right(unit);
    } catch (e) {
      return left(
        AppFailure(
          message: e.toString(),
        ),
      );
    }
  }

}
