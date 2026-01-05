import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:markme_student/core/error/failure.dart';
import 'package:markme_student/core/models/section.dart';

import 'edit_profile_repository.dart';

class EditProfileRepositoryImpl extends EditProfileRepository {
  final FirebaseFirestore firestore;
  EditProfileRepositoryImpl({required this.firestore});
  @override
  Future<Either<AppFailure, Unit>> updateStudentRollOrReg(
    String collegeId,
    String studentId,
    String? rollNo,
    String? regNo,
  ) async {
    try {
      final studentRef = firestore
          .collection("students")
          .doc(collegeId)
          .collection("students")
          .doc(studentId);

      final permissionRef = studentRef.collection("permissions").doc("main");

      // 1️⃣ Get permission document
      final permissionSnap = await permissionRef.get();

      bool canUpdateRollOrReg = true;

      if (!permissionSnap.exists) {
        // 🟢 First time → allow once
        await permissionRef.set({'canUpdateRollOrReg': true});
      } else {
        final data = permissionSnap.data() as Map<String, dynamic>;
        canUpdateRollOrReg = data['canUpdateRollOrReg'] ?? true;
      }
      // 2️⃣ Permission check
      if (!canUpdateRollOrReg) {
        return Left(
          AppFailure(
            message:
                "You are not allowed to update Roll No or Registration No again",
          ),
        );
      }

      // 3️⃣ Prepare update map
      final Map<String, dynamic> updateData = {};

      if (rollNo != null && rollNo.isNotEmpty) {
        updateData['rollNo'] = rollNo;
      }

      if (regNo != null && regNo.isNotEmpty) {
        updateData['regdNo'] = regNo;
      }

      if (updateData.isEmpty) {
        return Left(AppFailure(message: "Nothing to update"));
      }

      // 4️⃣ Update student document
      await studentRef.update(updateData);

      // 5️⃣ Disable permission after first update
      await permissionRef.set({
        'canUpdateRollOrReg': false,
      }, SetOptions(merge: true));

      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(AppFailure(message: "Firestore error: ${e.message}"));
    } catch (e) {
      return Left(AppFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<AppFailure, Section>> getSectionDetails(
      String collegeId,
      String sectionId,
      ) async {
    try {
      final sectionRef = firestore
          .collection("sections")
          .doc(collegeId)
          .collection("sections")
          .doc(sectionId);

      final sectionSnap = await sectionRef.get();

      // ✅ Handle missing document
      if (!sectionSnap.exists || sectionSnap.data() == null) {
        return Left(
          AppFailure(message: "Section not found"),
        );
      }
      final section = Section.fromMap(sectionSnap.data()!);
      return Right(section);
    } catch (e) {
      return Left(
        AppFailure(message: e.toString()),
      );
    }
  }
}
