// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'college_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollegeScheduleAdapter extends TypeAdapter<CollegeSchedule> {
  @override
  final int typeId = 3;

  @override
  CollegeSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CollegeSchedule(
      numberOfClasses: fields[0] as int,
      durationMinutes: fields[1] as int,
      schedules: (fields[2] as List).cast<SessionModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CollegeSchedule obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.numberOfClasses)
      ..writeByte(1)
      ..write(obj.durationMinutes)
      ..writeByte(2)
      ..write(obj.schedules);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollegeScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
