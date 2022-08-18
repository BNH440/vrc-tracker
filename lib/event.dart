import 'package:flutter/material.dart';
import 'package:vrc_ranks_app/Schema/Events.dart';
import 'package:requests/requests.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key, required this.title, required this.event_old})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Event event_old;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Event _event = Event();
  Event event = Event();

  @override
  Widget build(BuildContext context) {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
    };
    Requests.get(
            "https://www.robotevents.com/api/v2/events/${widget.event_old.id}",
            headers: headers)
        .then((value) => {
              event = Event.fromJson(jsonDecode(value.body)),
              setState(() {
                _event = event;
              })
            });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height: 50,
        color: Colors.grey[300],
        margin: const EdgeInsets.all(4),
        child: Center(
            child: ListView(children: [
          Text((event.name).toString()),
          Text((event.divisions?[0].id).toString()),
        ])),
      ),
    );
  }
}
