import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:vrc_ranks_app/Schema/Events.dart';
import 'package:vrc_ranks_app/team.dart';
import 'Request.dart' as Request;

class MatchPage extends StatefulWidget {
  const MatchPage(
      {Key? key, required this.title, required this.event_old, required this.match_number})
      : super(key: key);

  final String title;
  final Event event_old;
  final int match_number;

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
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
        if (event.divisions != null)
          if (event.divisions?[0].data?.data?[widget.match_number].alliances?.length != null)
            for (var prop in (event.divisions![0].data!.data![widget.match_number].alliances!))
              if (prop.teams != null)
                for (var prop2 in prop.teams!)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeamPage(
                                title: (prop2.team?.name).toString(),
                                event_old: event,
                                match_number: widget.match_number,
                                alliance_number: event.divisions?[0].data
                                            ?.data?[widget.match_number].alliances ==
                                        null
                                    ? 0
                                    : event
                                        .divisions![0].data!.data![widget.match_number].alliances!
                                        .indexOf(prop),
                                team_number: prop.teams == null ? 0 : prop.teams!.indexOf(prop2),
                                team_id: (prop2.team?.id).toString())),
                      );
                    },
                    child: Container(
                      height: 50,
                      color: Colors.grey[300],
                      margin: const EdgeInsets.all(4),
                      child: Center(
                        child: Text((prop2.team?.name).toString()),
                      ),
                    ),
                  ),
      ]),
    );
  }
}
