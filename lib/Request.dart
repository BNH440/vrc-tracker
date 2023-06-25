import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:requests/requests.dart';
import 'package:vrc_ranks_app/Hive/Team.dart' as hiveTeam;
import 'package:vrc_ranks_app/Schema/EventListByTeam.dart';
import 'package:vrc_ranks_app/Schema/MatchPrediction.dart';
import 'package:vrc_ranks_app/Schema/Rankings.dart';
import 'package:vrc_ranks_app/Schema/Team.dart';
import 'package:vrc_ranks_app/Schema/TeamsSearch.dart' as TeamsSearch;
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

Future<bool> _handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}

Future<List> isLocal(Position position, double latitude, double longitude) async {
  const metersInMile = 1609.34;

  // check if coordinates are within 60 miles of the user

  double distanceInMeters =
      Geolocator.distanceBetween(position.latitude, position.longitude, latitude, longitude);

  return [distanceInMeters < (metersInMile * 60), distanceInMeters];
}

Future<events.Events> getEventList(DateTime date) async {
  var utcDate = "${date.addDays(-1).format("yyyy-MM-dd")}T00:00:00Z";

  // var response = await Requests.get(
  //     "https://www.robotevents.com/api/v2/events?season[]=173&start=$utcDate&per_page=1000",
  //     headers: headers);
  var response = await Requests.get(
      "https://cache.vrctracker.blakehaug.com/eventList?date=$utcDate",
      headers: headers);

  var decoded = events.Events.fromJson(jsonDecode(response.body));

  if (decoded.data != null) {
    if (await _handleLocationPermission()) {
      Position position =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      for (var event in decoded.data!) {
        var result = await isLocal(position, event.location?.coordinates?.lat?.toDouble() ?? 0.0,
            event.location?.coordinates?.lon?.toDouble() ?? 0.0);
        var local = result[0];
        var distance = result[1];
        event.isLocal = local;
        event.distance = distance;
      }

      // decoded.data!.sort((a, b) => a.distance.compareTo(b.distance));
    }
  }

  log("Requested events");

  return decoded;
}

Future<events.Event> getEventDetails(String eventId) async {
  var response = await Requests.get(
      "https://cache.vrctracker.blakehaug.com/eventDetails?event=$eventId", // eventDetails
      headers: headers);

  var decoded = events.Event.fromJson(jsonDecode(response.body));

  if (decoded.divisions != null) {
    int i = 0;
    for (var div in decoded.divisions!) {
      // get div ids and fetch info
      var divIndex = i;
      var divId = div.id;
      var divResponse = await Requests.get(
          "https://www.robotevents.com/api/v2/events/$eventId/divisions/$divId/matches?per_page=1000", // events-divisions-matches-divx
          headers: headers);
      var divDecoded = division.Div.fromJson(jsonDecode(divResponse.body));

      divDecoded.data?.sort((a, b) => a.id!.compareTo(b.id!));

      decoded.divisions![divIndex].data = divDecoded;
      decoded.divisions![divIndex].order = i;

      var rankingsResponse = await Requests.get(
          "https://www.robotevents.com/api/v2/events/$eventId/divisions/$divId/rankings?per_page=1000", // events-divisions-rankings-divx
          headers: headers);

      var rankingsDecoded = Rankings.fromJson(jsonDecode(rankingsResponse.body));

      decoded.divisions![divIndex].rankings = rankingsDecoded;
      i++;
    }
  }

  var response2 = await Requests.get(
      "https://cache.vrctracker.blakehaug.com/teamList?event=$eventId", // teamList
      headers: headers);

  var decoded2 = TeamList.TeamList.fromJson(jsonDecode(response2.body));

  decoded.teams = decoded2;

  if (decoded.teams?.data?.isNotEmpty ?? false) {
    decoded.teams!.data!.sort((a, b) => compareNatural(a.number!, b.number!));
  }

  log("Requested event details");
  return decoded;
}

Future<List> getTeamDetails(String teamId, String compId) async {
  var response = await Requests.get(
      "https://cache.vrctracker.blakehaug.com/teamDetails?team=$teamId",
      headers: headers);

  var decoded = Team.fromJson(jsonDecode(response.body));

  var response2 = await Requests.get(
      "https://www.robotevents.com/api/v2/teams/$teamId/matches?event[]=$compId&per_page=1000",
      headers: headers);

  var decoded2 = MatchListByTeam.fromJson(jsonDecode(response2.body));

  decoded2.data?.sort((a, b) => a.id!.compareTo(b.id!));

  log("Requested team details");
  return [decoded, decoded2];
}

Future<Team> getTeam(String teamId) async {
  var decoded;

  var team = Hive.box<hiveTeam.Team>("teams").get(teamId);

  var cachedTeam = (team?.isValid() ?? false) ? hiveTeam.hiveTeamToTeam(team) : null;

  if (cachedTeam == null) {
    log("No cached team found");
    var response = await Requests.get(
        "https://cache.vrctracker.blakehaug.com/teamDetails?team=$teamId",
        headers: headers);

    decoded = Team.fromJson(jsonDecode(response.body));

    Hive.box<hiveTeam.Team>("teams").put(teamId, hiveTeam.teamToHiveTeam(decoded));
    log("Cached team");
  } else {
    log("Cached team found");
    decoded = cachedTeam;
  }

  var response2 = await Requests.get(
      "https://cache.vrctracker.blakehaug.com/teamEvents?team=$teamId",
      headers: headers);

  var decoded2 = EventListByTeam.fromJson(jsonDecode(response2.body));

  decoded.events = decoded2;

  log("Requested team details");
  return decoded;
}

Future<List<TeamsSearch.Item>> getTeams(String query, String grade) async {
  var response =
      await Requests.get("https://api.vrctracker.blakehaug.com/teams?search=$query&grade=$grade");

  List<TeamsSearch.Item> teams = [];

  for (var team in jsonDecode(response.body)) {
    teams.add(TeamsSearch.Item.fromJson(team["item"]));
  }

  log("Requested teams with query $query");
  return teams;
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
      "https://www.robotevents.com/api/v2/events/$compId/skills?type=driver&per_page=1000",
      headers: headers);

  var decodedDriver = Skills.Skills.fromJson(jsonDecode(responseDriver.body));

  var responseProg = await Requests.get(
      "https://www.robotevents.com/api/v2/events/$compId/skills?type=programming&per_page=1000",
      headers: headers);

  var decodedProg = Skills.Skills.fromJson(jsonDecode(responseProg.body));

  List<SkillsTotal> newList = [];

  if (decodedDriver.data != null) {
    for (var i = 0; i < decodedDriver.data!.length; i++) {
      newList.add(SkillsTotal(
          teamId: decodedDriver.data![i].team!.id ?? 0,
          teamNumber: decodedDriver.data![i].team!.name ?? "",
          driverScore: decodedDriver.data![i].score ?? 0,
          programmingScore: 0));
    }
  }

  if (decodedProg.data != null) {
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
  }

  if (newList.isNotEmpty) {
    newList.sort((a, b) =>
        (b.programmingScore + b.driverScore).compareTo(a.programmingScore + a.driverScore));
  }

  return newList;
}

Future<double> predictMatch(
    String red1, String red2, String blue1, String blue2, String matchNumber) async {
  var response = await Requests.get(
      "https://cache.vrctracker.blakehaug.com/predict?red1=$red1&red2=$red2&blue1=$blue1&blue2=$blue2");

  var decodedRes = MatchPrediction.fromJson(jsonDecode((response.body)));

  return decodedRes.redWinProbability ?? -1.00;
}
