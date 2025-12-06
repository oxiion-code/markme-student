import 'package:markme_student/features/class/models/class_session.dart';

class ClassSessionWithFlag {
  final ClassSession classSession;
  final bool isStudentPresent;
  const ClassSessionWithFlag({
    required this.classSession,
    required this.isStudentPresent,
  });
}
