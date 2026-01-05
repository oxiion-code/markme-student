import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../models/time_table.dart';
import 'time_table_repository.dart';

class TimeTableRepositoryImpl extends TimeTableRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  TimeTableRepositoryImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<Either<AppFailure, TimeTable>> fetchTimeTableForStudent(String sectionId,String collegeId) async {
    try {
      // 1️⃣ Get the section document to read currentSemesterId
      final sectionDoc = await firestore.collection('sections').doc(collegeId).collection('sections').doc(sectionId).get();
      if (!sectionDoc.exists) {
        return Left(AppFailure(message: "Section not found"));
      }

      final sectionData = sectionDoc.data()!;
      final currentSemesterId = sectionData['currentSemesterId'] as String?;

      if (currentSemesterId == null) {
        return Left(AppFailure(message: "Current semester not set for this section"));
      }

      // 2️⃣ Fetch timetable directly using currentSemesterId as document ID
      final timetableDoc = await firestore.collection('timetables').doc(collegeId).collection('timetables').doc(currentSemesterId).get();

      if (!timetableDoc.exists) {
        return Left(AppFailure(message: "No timetable found for the current semester"));
      }

      // 3️⃣ Map Firestore document to TimeTable model
      final timetable = TimeTable.fromMap(timetableDoc.data()!);

      return Right(timetable);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
