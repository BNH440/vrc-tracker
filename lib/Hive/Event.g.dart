// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 4;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as int,
      sku: fields[1] as String,
      name: fields[2] as String,
      start: fields[3] as String?,
      end: fields[4] as String?,
      location: fields[5] as Location?,
      divisions: (fields[6] as List?)?.cast<Divisions>(),
      level: fields[8] as String?,
      ongoing: fields[9] as bool?,
      awardsFinalized: fields[10] as bool?,
      isLocal: fields[11] as bool,
      distance: fields[12] as double,
      seasonId: fields[13] as String,
      schemaVersion: fields[14] as String,
    )..lastUpdated = fields[15] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sku)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.start)
      ..writeByte(4)
      ..write(obj.end)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.divisions)
      ..writeByte(8)
      ..write(obj.level)
      ..writeByte(9)
      ..write(obj.ongoing)
      ..writeByte(10)
      ..write(obj.awardsFinalized)
      ..writeByte(11)
      ..write(obj.isLocal)
      ..writeByte(12)
      ..write(obj.distance)
      ..writeByte(13)
      ..write(obj.seasonId)
      ..writeByte(14)
      ..write(obj.schemaVersion)
      ..writeByte(15)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
