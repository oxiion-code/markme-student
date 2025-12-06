import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:markme_student/features/student/models/student.dart';

import '../../../core/error/failure.dart';
import '../models/auth_info.dart';
import 'auth_repository.dart';

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthRepositoryImpl extends AuthRepository {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firestore;
  FirebaseStorage storage;

  AuthRepositoryImpl(this.firebaseAuth, this.firestore, this.storage);

  @override
  Future<Either<AppFailure, Student>> getUserdata({required String uid}) async {
    try {
      final docSnapshot = await firestore.collection("students").doc(uid).get();

      if (!docSnapshot.exists) {
        return Left(AppFailure(message: "User not registered"));
      }

      final data = docSnapshot.data()!;
      final user = Student.fromJson(data);

      final deviceToken = await FirebaseMessaging.instance.getToken();

      if (deviceToken != null && data["deviceToken"] != deviceToken) {
        await firestore.collection("students").doc(uid).update({
          "deviceToken": deviceToken,
        });
      }

      final updatedUser = user.copyWith(
        deviceToken: deviceToken ?? user.deviceToken,
      );

      return Right(updatedUser);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return Left(
          AppFailure(message: "You do not have permission to access this data"),
        );
      } else if (e.code == 'unavailable') {
        return Left(
          AppFailure(message: "Firestore service is currently unavailable"),
        );
      } else {
        return Left(AppFailure(message: "Firestore error: ${e.message}"));
      }
    } on TimeoutException {
      return Left(AppFailure(message: "Request timed out. Please try again."));
    } catch (e) {
      return Left(AppFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<AppFailure, void>> logout() async {
    try {
      await firebaseAuth.signOut();
      return Right(null);
    } on FirebaseAuthException catch (e) {
      // Firebase-specific errors
      return Left(AppFailure(message: "Logout failed: ${e.message}"));
    } on TimeoutException {
      // In case signOut somehow times out
      return Left(AppFailure(message: "Logout timed out. Please try again."));
    } catch (e) {
      // Catch any other unexpected errors
      return Left(
        AppFailure(message: "Unexpected error during logout: ${e.toString()}"),
      );
    }
  }

  // send otp

  @override
  Future<Either<AppFailure, String>> sendOtp({
    required String phoneNumber,
  }) async {
    try {
      final completer = Completer<Either<AppFailure, String>>();

      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await firebaseAuth.signInWithCredential(credential);
            // Auto verification handled, no need to complete completer here
          } catch (e) {
            //failed
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          // Firebase-specific errors
          String message;
          switch (e.code) {
            case 'invalid-phone-number':
              message = "The phone number entered is invalid";
              break;
            case 'quota-exceeded':
              message = "SMS quota exceeded. Try again later";
              break;
            default:
              message = e.message ?? "OTP sending failed";
          }
          completer.complete(Left(AppFailure(message: message)));
        },
        codeSent: (String verificationId, int? resendToken) {
          completer.complete(Right(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );

      return completer.future;
    } on FirebaseAuthException catch (e) {
      return Left(AppFailure(message: "Firebase error: ${e.message}"));
    } on TimeoutException {
      return Left(
        AppFailure(message: "OTP request timed out. Please try again."),
      );
    } catch (e) {
      return Left(AppFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  //verify the otp
  @override
  Future<Either<AppFailure, AuthInfo>> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      final user = firebaseAuth.currentUser;
      if (user == null) {
        return Left(AppFailure(message: "No user is currently signed in"));
      }

      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      return Right(
        AuthInfo(
          uid: user.uid,
          phoneNumber: user.phoneNumber!,
          isNewUser: isNewUser,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-verification-code':
          message = "The OTP entered is invalid";
          break;
        case 'session-expired':
          message = "The OTP has expired. Please request a new one";
          break;
        case 'too-many-requests':
          message = "Too many requests. Please try again later";
          break;
        default:
          message = e.message ?? "OTP verification failed";
      }
      return Left(AppFailure(message: message));
    } on TimeoutException {
      return Left(
        AppFailure(message: "OTP verification timed out. Please try again."),
      );
    } catch (e) {
      return Left(AppFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<AppFailure, Student>> updateStudentData({
    required Student student,
    File? profilePhoto,
  }) async {
    try {
      String? downloadUrl;

      if (profilePhoto != null) {
        // Use UID instead of regdNo for storage path
        final uid = firebaseAuth.currentUser!.uid;
        downloadUrl = await uploadProfileImage(profilePhoto, uid);
      }

      final updatedStudent = student.copyWith(
        profilePhotoUrl: downloadUrl ?? student.profilePhotoUrl,
      );

      final uid = firebaseAuth.currentUser!.uid;

      await firestore
          .collection("students")
          .doc(uid)
          .set(updatedStudent.toMap());

      return Right(updatedStudent);
    } on FirebaseException catch (e) {
      // Firestore-specific errors
      return Left(AppFailure(message: "Firestore error: ${e.message}"));
    } on TimeoutException {
      return Left(AppFailure(message: "Request timed out. Please try again."));
    } catch (e) {
      return Left(AppFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  Future<String> uploadProfileImage(File file, String uid) async {
    try {
      // Create a separate folder for each student using their UID
      final ref = storage
          .ref()
          .child("student_profiles") // main folder
          .child(uid) // subfolder for this student
          .child("profile.jpg"); // file name

      final uploadTask = ref.putFile(file);

      // Wait for upload to complete
      await uploadTask.whenComplete(() => null);

      // Get download URL
      final url = await ref.getDownloadURL();

      return url;
    } on FirebaseException catch (e) {
      // Storage-specific errors
      throw Exception("Image upload failed: ${e.message}");
    } on TimeoutException {
      throw Exception("Image upload timed out. Please try again.");
    } catch (e) {
      throw Exception("Unexpected error during image upload: $e");
    }
  }
}