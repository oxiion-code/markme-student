import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:markme_student/core/error/failure.dart';
import 'package:markme_student/features/profile_verification/models/qualification.dart';
import 'package:markme_student/features/profile_verification/repositories/profile_verification_repository.dart';

class ProfileVerificationRepositoryImpl extends ProfileVerificationRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProfileVerificationRepositoryImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<Either<AppFailure, Unit>> uploadEducationalDetails(
    String studentId,
    String collegeId,
    List<Qualification> qualifications,
  ) async {
    try {
      final qualificationCollection = firestore
          .collection('students')
          .doc(collegeId)
          .collection('students')
          .doc(studentId)
          .collection('qualification_details');

      final WriteBatch batch = firestore.batch();

      bool documentUploaded = false; // 🔑 track document existence

      for (final qualification in qualifications) {
        final docRef = qualificationCollection.doc(
          "${qualification.qualificationType} Certificate",
        );

        final snapshot = await docRef.get();

        Qualification finalQualification = qualification;

        if (snapshot.exists) {
          final existing = Qualification.fromMap(snapshot.data()!);

          // ✅ if document already exists → mark true
          if (existing.documentUrl != null &&
              existing.documentUrl!.isNotEmpty) {
            documentUploaded = true;
          }

          finalQualification = qualification.copyWith(
            documentUrl: existing.documentUrl,
            isDocumentVerified: existing.isDocumentVerified,
          );
        }

        batch.set(docRef, finalQualification.toMap(), SetOptions(merge: true));
      }

      await batch.commit();

      // 🔥 Update student profile status correctly
      await _updateStudentProfileStatus(
        collegeId: collegeId,
        studentId: studentId,
        educationUploaded: true,
        documentUploaded: documentUploaded,
      );

      return const Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> uploadVerificationDocuments(
    String collegeId,
    String studentId,
    Map<String, File> documents,
  ) async {
    try {
      final qualificationCollection = firestore
          .collection('students')
          .doc(collegeId)
          .collection('students')
          .doc(studentId)
          .collection('qualification_details');
      for (final entry in documents.entries) {
        final qualificationType = entry.key;
        final file = entry.value;

        final storageRef = storage.ref(
          'student_profiles/$studentId/documents/$qualificationType.pdf',
        );

        await storageRef.putFile(file);
        final downloadUrl = await storageRef.getDownloadURL();

        final docRef = qualificationCollection.doc(qualificationType);
        final snapshot = await docRef.get();

        Qualification updatedQualification;

        if (snapshot.exists) {
          final existing = Qualification.fromMap(snapshot.data()!);
          updatedQualification = existing.copyWith(
            documentUrl: downloadUrl,
            isDocumentVerified: false,
          );
        } else {
          updatedQualification = Qualification(
            qualificationType: qualificationType,
            institutionName: '',
            boardOrUniversity: '',
            passingOutYear: 0,
            documentUrl: downloadUrl,
            isDocumentVerified: false,
            notes: '',
            percentage: 0.0,
            streamOrSpecialization: '',
          );
        }

        await docRef.set(updatedQualification.toMap(), SetOptions(merge: true));
      }
      await _updateStudentProfileStatus(
        collegeId: collegeId,
        studentId: studentId,
        educationUploaded: false,
        documentUploaded: true,
      );

      return const Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<void> _updateStudentProfileStatus({
    required String collegeId,
    required String studentId,
    required bool educationUploaded,
    required bool documentUploaded,
  }) async {
    String status = 'no_data';

    if (educationUploaded && documentUploaded) {
      status = 'both_uploaded';
    } else if (educationUploaded) {
      status = 'e_uploaded';
    } else if (documentUploaded) {
      status = 'd_uploaded';
    }

    await firestore
        .collection('students')
        .doc(collegeId)
        .collection('students')
        .doc(studentId)
        .set({'isProfileVerified': status}, SetOptions(merge: true));
  }

  @override
  Future<Either<AppFailure, String>> checkAccountVerificationStatus(
    String collegeId,
    String studentId,
  ) async {
    try {
      final doc = await firestore
          .collection('students')
          .doc(collegeId)
          .collection('students')
          .doc(studentId)
          .get();

      if (!doc.exists) {
        return right('no_data'); // or left if you prefer
      }

      final data = doc.data();

      final String status = (data?['isProfileVerified'] ?? 'no_data') as String;
      return right(status);
    } catch (e) {
      return left(AppFailure(message: e.toString()));
    }
  }
}
