// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'college_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollegeDetailAdapter extends TypeAdapter<CollegeDetail> {
  @override
  final int typeId = 2;

  @override
  CollegeDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CollegeDetail(
      bannerLink: fields[0] as String?,
      collegeName: fields[1] as String,
      isSuperAdminExist: fields[2] as bool,
      logo: fields[3] as String?,
      id: fields[4] as String,
      collegeSchedule: fields[5] as CollegeSchedule?,
    );
  }

  @override
  void write(BinaryWriter writer, CollegeDetail obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.bannerLink)
      ..writeByte(1)
      ..write(obj.collegeName)
      ..writeByte(2)
      ..write(obj.isSuperAdminExist)
      ..writeByte(3)
      ..write(obj.logo)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.collegeSchedule);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollegeDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
