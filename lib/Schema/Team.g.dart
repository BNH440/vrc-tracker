// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Team.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationAdapter extends TypeAdapter<Location> {
  @override
  final int typeId = 2;

  @override
  Location read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Location()
      .._venue = fields[0] as String?
      .._address1 = fields[1] as String?
      .._address2 = fields[2] as String?
      .._city = fields[3] as String?
      .._region = fields[4] as String?
      .._postcode = fields[5] as String?
      .._country = fields[6] as String?
      .._coordinates = fields[7] as Coordinates?;
  }

  @override
  void write(BinaryWriter writer, Location obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj._venue)
      ..writeByte(1)
      ..write(obj._address1)
      ..writeByte(2)
      ..write(obj._address2)
      ..writeByte(3)
      ..write(obj._city)
      ..writeByte(4)
      ..write(obj._region)
      ..writeByte(5)
      ..write(obj._postcode)
      ..writeByte(6)
      ..write(obj._country)
      ..writeByte(7)
      ..write(obj._coordinates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CoordinatesAdapter extends TypeAdapter<Coordinates> {
  @override
  final int typeId = 3;

  @override
  Coordinates read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Coordinates()
      .._lat = fields[0] as double?
      .._lon = fields[1] as double?;
  }

  @override
  void write(BinaryWriter writer, Coordinates obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._lat)
      ..writeByte(1)
      ..write(obj._lon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoordinatesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
