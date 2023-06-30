import 'package:hive/hive.dart';
import 'package:vrc_ranks_app/globals.dart' as globals;
import '../Schema/Events.dart' show Divisions, Location;
import '../Schema/Events.dart' as schema;

part 'Event.g.dart';

@HiveType(typeId: 4)
class Event extends HiveObject {
  Event(
      {required this.id,
      required this.sku,
      required this.name,
      required this.start,
      required this.end,
      required this.location,
      required this.divisions,
      // required this.teams,
      required this.level,
      required this.ongoing,
      required this.awardsFinalized,
      required this.isLocal,
      required this.distance,
      required this.seasonId,
      required this.schemaVersion});

  @HiveField(0)
  int id;

  @HiveField(1)
  String sku;

  @HiveField(2)
  String name;

  @HiveField(3)
  String? start;

  @HiveField(4)
  String? end;

  @HiveField(5)
  Location? location;

  @HiveField(6)
  List<Divisions>? divisions;

  // @HiveField(7)
  // List<String>? teams;

  @HiveField(8)
  String? level;

  @HiveField(9)
  bool? ongoing;

  @HiveField(10)
  bool? awardsFinalized;

  @HiveField(11)
  bool isLocal = false;

  @HiveField(12)
  double distance = double.maxFinite;

  @HiveField(13)
  String seasonId;

  @HiveField(14)
  String schemaVersion;

  @HiveField(15)
  DateTime lastUpdated = DateTime.now();

  bool isValid() {
    var currentSeason = seasonId == globals.seasonId;
    var currentSchema = schemaVersion == globals.eventSchemaVersion;
    if (currentSeason == false || currentSchema == false) {
      delete();
      return false;
    }
    return true;
  }
}

Event eventToHiveEvent(schema.Event event) {
  return Event(
      id: event.id!,
      sku: event.sku!,
      name: event.name!,
      start: event.start,
      end: event.end,
      location: event.location,
      divisions: event.divisions,
      // teams: null,
      level: event.level,
      ongoing: event.ongoing,
      awardsFinalized: event.awardsFinalized,
      isLocal: event.isLocal,
      distance: event.distance,
      seasonId: globals.seasonId,
      schemaVersion: globals.eventSchemaVersion);
}

schema.Event hiveEventToEvent(Event event) {
  return schema.Event(
      id: event.id,
      sku: event.sku,
      name: event.name,
      start: event.start,
      end: event.end,
      location: event.location,
      divisions: event.divisions,
      // teams: null,
      level: event.level,
      ongoing: event.ongoing,
      awardsFinalized: event.awardsFinalized,
      isLocal: event.isLocal,
      distance: event.distance);
}