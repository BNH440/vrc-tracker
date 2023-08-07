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
      divisions: (fields[6] as List?)?.cast<Division>(),
      teams: (fields[7] as HiveList?)?.castHiveList(),
      level: fields[8] as String?,
      ongoing: fields[9] as bool?,
      awardsFinalized: fields[10] as bool?,
      seasonName: fields[11] as String?,
      isLocal: fields[40] as bool,
      distance: fields[41] as double,
      seasonId: fields[42] as String,
      schemaVersion: fields[43] as String,
    )..lastUpdated = fields[44] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(17)
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
      ..writeByte(7)
      ..write(obj.teams)
      ..writeByte(8)
      ..write(obj.level)
      ..writeByte(9)
      ..write(obj.ongoing)
      ..writeByte(10)
      ..write(obj.awardsFinalized)
      ..writeByte(11)
      ..write(obj.seasonName)
      ..writeByte(40)
      ..write(obj.isLocal)
      ..writeByte(41)
      ..write(obj.distance)
      ..writeByte(42)
      ..write(obj.seasonId)
      ..writeByte(43)
      ..write(obj.schemaVersion)
      ..writeByte(44)
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

class MatchAdapter extends TypeAdapter<Match> {
  @override
  final int typeId = 6;

  @override
  Match read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Match(
      id: fields[0] as int,
      round: fields[2] as int,
      instance: fields[3] as int,
      matchnum: fields[4] as int,
      scheduled: fields[5] as String?,
      started: fields[6] as String?,
      field: fields[7] as String?,
      scored: fields[8] as bool?,
      name: fields[1] as String,
      redAlliance: fields[9] as Alliance,
      blueAlliance: fields[10] as Alliance,
    )..lastUpdated = fields[44] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Match obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.round)
      ..writeByte(3)
      ..write(obj.instance)
      ..writeByte(4)
      ..write(obj.matchnum)
      ..writeByte(5)
      ..write(obj.scheduled)
      ..writeByte(6)
      ..write(obj.started)
      ..writeByte(7)
      ..write(obj.field)
      ..writeByte(8)
      ..write(obj.scored)
      ..writeByte(9)
      ..write(obj.redAlliance)
      ..writeByte(10)
      ..write(obj.blueAlliance)
      ..writeByte(44)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DivisionAdapter extends TypeAdapter<Division> {
  @override
  final int typeId = 7;

  @override
  Division read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Division(
      id: fields[0] as int,
      name: fields[1] as String?,
      order: fields[2] as int?,
      matches: (fields[3] as List?)?.cast<Match>(),
      rankings: (fields[4] as List?)?.cast<Rank>(),
    )..lastUpdated = fields[44] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Division obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.order)
      ..writeByte(3)
      ..write(obj.matches)
      ..writeByte(4)
      ..write(obj.rankings)
      ..writeByte(44)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DivisionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AllianceAdapter extends TypeAdapter<Alliance> {
  @override
  final int typeId = 8;

  @override
  Alliance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Alliance(
      color: fields[0] as AllianceColor,
      score: fields[1] as int?,
      teams: (fields[2] as HiveList).castHiveList(),
    )..lastUpdated = fields[44] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Alliance obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.color)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.teams)
      ..writeByte(44)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllianceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RankAdapter extends TypeAdapter<Rank> {
  @override
  final int typeId = 10;

  @override
  Rank read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rank(
      id: fields[0] as int?,
      rank: fields[1] as int?,
      team: (fields[2] as HiveList).castHiveList(),
      wins: fields[3] as int?,
      losses: fields[4] as int?,
      ties: fields[5] as int?,
      wp: fields[6] as int?,
      ap: fields[7] as int?,
      sp: fields[8] as int?,
      highScore: fields[9] as int?,
      averagePoints: fields[10] as num?,
      totalPoints: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Rank obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.rank)
      ..writeByte(2)
      ..write(obj.team)
      ..writeByte(3)
      ..write(obj.wins)
      ..writeByte(4)
      ..write(obj.losses)
      ..writeByte(5)
      ..write(obj.ties)
      ..writeByte(6)
      ..write(obj.wp)
      ..writeByte(7)
      ..write(obj.ap)
      ..writeByte(8)
      ..write(obj.sp)
      ..writeByte(9)
      ..write(obj.highScore)
      ..writeByte(10)
      ..write(obj.averagePoints)
      ..writeByte(11)
      ..write(obj.totalPoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AllianceColorAdapter extends TypeAdapter<AllianceColor> {
  @override
  final int typeId = 9;

  @override
  AllianceColor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AllianceColor.red;
      case 1:
        return AllianceColor.blue;
      default:
        return AllianceColor.red;
    }
  }

  @override
  void write(BinaryWriter writer, AllianceColor obj) {
    switch (obj) {
      case AllianceColor.red:
        writer.writeByte(0);
        break;
      case AllianceColor.blue:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllianceColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
