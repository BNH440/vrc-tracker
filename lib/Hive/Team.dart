import 'package:hive/hive.dart';
import '../Schema/Team.dart' as schema;
import '../Schema/Events.dart' show Location;
import 'package:vrc_ranks_app/globals.dart' as globals;

part 'Team.g.dart';

@HiveType(typeId: 1)
class Team extends HiveObject {
  Team(
      {required this.id,
      required this.number,
      required this.teamName,
      required this.organization,
      required this.grade,
      required this.location,
      required this.seasonId,
      required this.schemaVersion});

  @HiveField(0)
  int id;

  @HiveField(1)
  String number;

  @HiveField(2)
  String teamName;

  @HiveField(3)
  String organization;

  @HiveField(4)
  String grade;

  @HiveField(5)
  Location location;

  @HiveField(6)
  String seasonId;

  @HiveField(7)
  String schemaVersion;

  @HiveField(8)
  DateTime lastUpdated = DateTime.now();

  bool isValid() {
    var currentSeason = seasonId == globals.seasonId;
    var currentSchema = schemaVersion == globals.teamSchemaVersion;
    if (currentSeason == false || currentSchema == false) {
      delete();
      return false;
    }
    return true;
  }
}

Team teamToHiveTeam(schema.Team team) {
  return Team(
      id: team.id!,
      number: team.number!,
      teamName: team.teamName!,
      organization: team.organization!,
      grade: team.grade!,
      location: team.location!,
      seasonId: globals.seasonId,
      schemaVersion: globals.teamSchemaVersion);
}

schema.Team? hiveTeamToTeam(Team? team) {
  if (team == null) {
    return null;
  }

  return schema.Team(
      id: team.id,
      number: team.number,
      teamName: team.teamName,
      organization: team.organization,
      grade: team.grade,
      location: team.location);
}
