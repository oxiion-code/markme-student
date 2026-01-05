import 'package:hive/hive.dart';
import 'session_model.dart';

part 'college_schedule.g.dart';

@HiveType(typeId: 3)
class CollegeSchedule {

  @HiveField(0)
  final int numberOfClasses;

  @HiveField(1)
  final int durationMinutes;

  @HiveField(2)
  final List<SessionModel> schedules;

  const CollegeSchedule({
    required this.numberOfClasses,
    required this.durationMinutes,
    required this.schedules,
  });

  factory CollegeSchedule.fromMap(Map<String, dynamic> map) {
    return CollegeSchedule(
      numberOfClasses: map['numberOfClasses'] ?? 0,
      durationMinutes: map['durationMinutes'] ?? 0,
      schedules: (map['schedules'] as List<dynamic>? ?? [])
          .map((e) => SessionModel.fromMap(
        Map<String, dynamic>.from(e),
      ))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'numberOfClasses': numberOfClasses,
    'durationMinutes': durationMinutes,
    'schedules': schedules.map((e) => e.toMap()).toList(),
  };
}
