import 'package:hive/hive.dart';
import '../models/college_detail.dart';


class CollegeHiveService {
  static const String _boxName = 'college_box';
  static const String _collegeKey = 'selected_college';

  /// Open box (call once in app start)
  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<CollegeDetail>(_boxName);
    }
  }

  /// Save selected college
  static Future<void> saveCollege(CollegeDetail college) async {
    final box = Hive.box<CollegeDetail>(_boxName);
    await box.put(_collegeKey, college);
  }

  /// Get selected college
  static CollegeDetail? getCollege() {
    final box = Hive.box<CollegeDetail>(_boxName);
    return box.get(_collegeKey);
  }

  /// Check if college exists
  static bool hasCollege() {
    final box = Hive.box<CollegeDetail>(_boxName);
    return box.containsKey(_collegeKey);
  }

  /// Delete selected college
  static Future<void> deleteCollege() async {
    final box = Hive.box<CollegeDetail>(_boxName);
    await box.delete(_collegeKey);
  }

  /// Clear entire college box (use carefully)
  static Future<void> clearAll() async {
    final box = Hive.box<CollegeDetail>(_boxName);
    await box.clear();
  }
}
