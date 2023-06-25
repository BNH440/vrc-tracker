import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import '../Schema/Team.dart' as schema;

part 'Team.g.dart';

@HiveType(typeId: 1)
class Team extends HiveObject {
  Team(
      {required this.id,
      required this.number,
      required this.teamName,
      required this.organization,
      required this.grade,
      required this.seasonId});

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
  String seasonId;

  bool isValid() {
    return seasonId == dotenv.env['SEASON_ID'];
  }
}

Team teamToHiveTeam(schema.Team team) {
  return Team(
      id: team.id!,
      number: team.number!,
      teamName: team.teamName!,
      organization: team.organization!,
      grade: team.grade!,
      seasonId: dotenv.env['SEASON_ID']!);
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
      grade: team.grade);
}
