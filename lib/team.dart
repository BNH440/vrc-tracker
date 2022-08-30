import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:vrc_ranks_app/Schema/Events.dart';
import 'Request.dart' as Request;

class TeamPage extends StatefulWidget {
  const TeamPage(
      {Key? key,
      required this.title,
      required this.event_old,
      required this.match_number,
      required this.team_number})
      : super(key: key);

  final String title;
  final Event event_old;
  final int match_number;
  final int team_number;

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  Event _event = Event();
  Event event = Event();

  @override
  void initState() {
    super.initState();
    Request.getEventDetails(widget.event_old.id.toString()).then((value) {
      if (this.mounted) {
        setState(() {
          _event = value;
          event = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final getEventDetailsThrottled = throttle(
      () async => {
        event = await Request.getEventDetails(widget.event_old.id.toString()),
        if (this.mounted)
          {
            setState(() {
              _event = event;
              event = event;
            }),
          },
      },
      const Duration(seconds: 2),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              getEventDetailsThrottled();
            },
          ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        //f
      ]),
    );
  }
}
