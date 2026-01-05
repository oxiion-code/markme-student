import 'package:hive/hive.dart';

part 'session_model.g.dart';

@HiveType(typeId: 4)
class SessionModel {

  @HiveField(0)
  final int index;

  @HiveField(1)
  final int startMinute;

  @HiveField(2)
  final int endMinute;

  const SessionModel({
    required this.index,
    required this.startMinute,
    required this.endMinute,
  });

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      index: map['index'] ?? 0,
      startMinute: map['startMinute'] ?? 0,
      endMinute: map['endMinute'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'index': index,
    'startMinute': startMinute,
    'endMinute': endMinute,
  };
}
