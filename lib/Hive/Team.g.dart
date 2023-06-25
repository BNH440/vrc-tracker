// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Team.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeamAdapter extends TypeAdapter<Team> {
  @override
  final int typeId = 1;

  @override
  Team read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Team(
      id: fields[0] as int,
      number: fields[1] as String,
      teamName: fields[2] as String,
      organization: fields[3] as String,
      grade: fields[4] as String,
      seasonId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Team obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.teamName)
      ..writeByte(3)
      ..write(obj.organization)
      ..writeByte(4)
      ..write(obj.grade)
      ..writeByte(5)
      ..write(obj.seasonId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
