import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String reviewId;
  final String classId;
  final String studentId;
  final Map<String, int> ratings; // key: parameter (e.g., "clarity"), value: 1-5
  final String comment;
  final DateTime createdAt;

  Review({
    required this.reviewId,
    required this.classId,
    required this.studentId,
    required this.ratings,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      reviewId: map['reviewId'] ?? '',
      classId: map['classId'] ?? '',
      studentId: map['studentId'] ?? '',
      ratings: Map<String, int>.from(map['ratings'] ?? {}),
      comment: map['comment'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'classId': classId,
      'studentId': studentId,
      'ratings': ratings,
      'comment': comment,
      'createdAt': createdAt,
    };
  }
}
