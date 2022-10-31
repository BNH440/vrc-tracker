import 'dart:developer';

import 'package:requests/requests.dart';
import 'package:vrc_ranks_app/Schema/Rankings.dart';
import 'package:vrc_ranks_app/Schema/Team.dart';
import 'dart:convert';
import 'Schema/Events.dart' as events;
import 'Schema/Division.dart' as division;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_date/dart_date.dart';
import 'Schema/MatchListByTeam.dart';
import 'Schema/TeamList.dart' as TeamList;

var headers = {
  'Accept': 'application/json',
  'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
};

Future<events.Events> getEventList(DateTime date, String grade) async {
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

  decoded.teams!.data!.sort((a, b) => a.number!.compareTo(b.number!));

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

  log("Requested team details");
  return decoded;
}
