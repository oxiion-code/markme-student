import 'package:markme_student/features/opportunities/models/placement_session.dart';
import 'package:markme_student/features/student/models/student.dart';

class PlacementArgs {
  final Student student;
  final PlacementSession placementSession;
  PlacementArgs({required this.student, required this.placementSession});
}