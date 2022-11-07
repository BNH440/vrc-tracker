import 'dart:developer';

import 'package:requests/requests.dart';
import 'package:vrc_ranks_app/Schema/EventListByTeam.dart';
import 'package:vrc_ranks_app/Schema/Rankings.dart';
import 'package:vrc_ranks_app/Schema/Team.dart';
import 'dart:convert';
import 'Schema/Events.dart' as events;
import 'Schema/Division.dart' as division;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_date/dart_date.dart';
import 'Schema/MatchListByTeam.dart';
import 'Schema/Skills.dart' as Skills;
import 'Schema/TeamList.dart' as TeamList;

var headers = {
  'Accept': 'application/json',
  'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
};

Future<events.Events> getEventList(DateTime date) async {
  var utcDate = "${date.addDays(-1).toUTC.format("yyyy-MM-dd")}T00:00:00Z";

  var response = await Requests.get(
      "https://www.robotevents.com/api/v2/events?season[]=173&start=$utcDate&per_page=1000",
      headers: headers);

  var decoded = events.Events.fromJson(jsonDecode(response.body));
  log("Requested events");

  return decoded;
}

Future<events.Event> getEventDetails(String eventId) async {
  List<Rankings> rankings = [];
  var response =
      await Requests.get("https://www.robotevents.com/api/v2/events/$eventId", headers: headers);

  var decoded = events.Event.fromJson(jsonDecode(response.body));

  if (decoded.divisions != null) {
    for (var div in decoded.divisions!) {
      // get div ids and fetch info
      var divId = div.id;
      var divResponse = await Requests.get(
          "https://www.robotevents.com/api/v2/events/$eventId/divisions/$divId/matches?per_page=1000",
          headers: headers);
      var divDecoded = division.Div.fromJson(jsonDecode(divResponse.body));

      divDecoded.data?.sort((a, b) => a.id!.compareTo(b.id!));

      decoded.divisions![divId! - 1].data = divDecoded;

      var rankingsResponse = await Requests.get(
          "https://www.robotevents.com/api/v2/events/$eventId/divisions/$divId/rankings?per_page=1000",
          headers: headers);

      var rankingsDecoded = Rankings.fromJson(jsonDecode(rankingsResponse.body));

      rankings.add(rankingsDecoded);
    }
  }

  decoded.rankings = rankings;

  var response2 = await Requests.get(
      "https://www.robotevents.com/api/v2/events/$eventId/teams?per_page=1000",
      headers: headers);

  var decoded2 = TeamList.TeamList.fromJson(jsonDecode(response2.body));

  decoded.teams = decoded2;

  if (decoded.teams?.data?.isNotEmpty ?? false) {
    decoded.teams!.data!.sort((a, b) => a.number!.compareTo(b.number!));
  }

  log("Requested event details");
  return decoded;
}

Future<List> getTeamDetails(String teamId, String compId) async {
  var response =
      await Requests.get("https://www.robotevents.com/api/v2/teams/$teamId", headers: headers);

  var decoded = Team.fromJson(jsonDecode(response.body));

  var response2 = await Requests.get(
      "https://www.robotevents.com/api/v2/teams/$teamId/matches?event[]=$compId",
      headers: headers);

  var decoded2 = MatchListByTeam.fromJson(jsonDecode(response2.body));

  log("Requested team details");
  return [decoded, decoded2];
}

Future<Team> getTeam(String teamId) async {
  var response =
      await Requests.get("https://www.robotevents.com/api/v2/teams/$teamId", headers: headers);

  var decoded = Team.fromJson(jsonDecode(response.body));

  var response2 = await Requests.get(
      "https://www.robotevents.com/api/v2/teams/$teamId/events?season[]=173",
      headers: headers);

  var decoded2 = EventListByTeam.fromJson(jsonDecode(response2.body));

  decoded.events = decoded2;

  log("Requested team details");
  return decoded;
}

class SkillsTotal {
  int teamId;
  String teamNumber;
  int driverScore;
  int programmingScore;

  SkillsTotal(
      {required this.teamId,
      required this.teamNumber,
      required this.driverScore,
      required this.programmingScore});
}

Future<List<SkillsTotal>> getSkills(String compId) async {
  var responseDriver = await Requests.get(
      "https://www.robotevents.com/api/v2/events/$compId/skills?type=driver",
      headers: headers);

  var decodedDriver = Skills.Skills.fromJson(jsonDecode(responseDriver.body));

  var responseProg = await Requests.get(
      "https://www.robotevents.com/api/v2/events/$compId/skills?type=programming",
      headers: headers);

  var decodedProg = Skills.Skills.fromJson(jsonDecode(responseProg.body));

  List<SkillsTotal> newList = [];

  for (var i = 0; i < decodedDriver.data!.length; i++) {
    newList.add(SkillsTotal(
        teamId: decodedDriver.data![i].team!.id ?? 0,
        teamNumber: decodedDriver.data![i].team!.name ?? "",
        driverScore: decodedDriver.data![i].score ?? 0,
        programmingScore: 0));
  }

  for (var i = 0; i < decodedProg.data!.length; i++) {
    if (newList.any((element) => element.teamId == decodedProg.data?[i].team?.id)) {
      newList
          .firstWhere((element) => element.teamId == decodedProg.data?[i].team?.id)
          .programmingScore = decodedProg.data?[i].score ?? 0;
    } else {
      newList.add(SkillsTotal(
          teamId: decodedProg.data![i].team!.id ?? 0,
          teamNumber: decodedProg.data![i].team!.name ?? "",
          driverScore: 0,
          programmingScore: decodedProg.data![i].score ?? 0));
    }
  }

  if (newList.isNotEmpty) {
    newList.sort((a, b) =>
        (b.programmingScore + b.driverScore).compareTo(a.programmingScore + a.driverScore));
  }

  return newList;
}
