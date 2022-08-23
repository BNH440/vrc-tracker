import 'package:requests/requests.dart';
import 'dart:convert';
import 'Schema/Events.dart' as events;
import 'Schema/Division.dart' as division;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_date/dart_date.dart';

var headers = {
  'Accept': 'application/json',
  'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
};

var utc = "${DateTime.now().format("yyyy-MM-dd")}T00:00:00Z";

Future<events.Events> getEventList() async {
  var response = await Requests.get(
      "https://www.robotevents.com/api/v2/events?season[]=173&start=$utc",
      headers: headers);

  var decoded = events.Events.fromJson(jsonDecode(response.body));

  return decoded;
}

Future<events.Event> getEventDetails(String eventId) async {
  var response = await Requests.get(
      "https://www.robotevents.com/api/v2/events/$eventId",
      headers: headers);

  var decoded = events.Event.fromJson(jsonDecode(response.body));

  if (decoded.divisions != null) {
    for (var div in decoded.divisions!) {
      // get div ids and fetch info
      var divId = div.id;
      var divResponse = await Requests.get(
          // "https://www.robotevents.com/api/v2/events/$eventId/divisions/$divId/matches",
          "https://www.robotevents.com/api/v2/events/48087/divisions/$divId/matches",
          headers: headers);
      var divDecoded = division.Div.fromJson(jsonDecode(divResponse.body));
      decoded.divisions![divId! - 1].data = divDecoded;
    }
  }
  return decoded;
}
