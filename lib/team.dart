import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:vrc_ranks_app/Schema/Events.dart';
import 'package:vrc_ranks_app/Schema/Team.dart';
import 'Request.dart' as Request;

class TeamPage extends StatefulWidget {
  const TeamPage(
      {Key? key,
      required this.title,
      required this.event_old,
      required this.match_number,
      required this.alliance_number,
      required this.team_number,
      required this.team_id})
      : super(key: key);

  final String title;
  final Event event_old;
  final int match_number;
  final int team_number;
  final int alliance_number;
  final String team_id;

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  Event _event = Event();
  Team _team = Team();
  Event event = Event();
  Team team = Team();

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
    Request.getTeamDetails((widget.team_id).toString()).then((value) {
      if (this.mounted) {
        setState(() {
          _team = value;
          team = value;
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
    final getTeamDetailsThrottled = throttle(
      () async => {
        team = await Request.getTeamDetails((widget.team_id).toString()),
        if (this.mounted)
          {
            setState(() {
              _team = team;
              team = team;
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
              getTeamDetailsThrottled();
            },
          ),
        ],
      ),
      body: (team.teamName).toString() == "null"
          ? const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            )
          : ListView(padding: const EdgeInsets.all(8), children: <Widget>[
              Text('Team Number: ${team.number}'),
              Text('Team Name: ${team.teamName}'),
              Text('Team Organization: ${team.organization}'),
            ]),
    );
  }
}
