import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:vrc_ranks_app/Schema/MatchListByTeam.dart';
import 'package:vrc_ranks_app/Schema/Team.dart';
import 'package:vrc_ranks_app/Schema/Events.dart' as Events;
import 'Request.dart' as Request;
import 'match.dart';

class TeamPage extends StatefulWidget {
  const TeamPage(
      {Key? key,
      required this.title,
      required this.team_id,
      required this.match_id,
      required this.event_old})
      : super(key: key);

  final String title;
  final String team_id;
  final String match_id;
  final Events.Event event_old;

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  Team _team = Team();
  Team team = Team();
  MatchListByTeam _matches = MatchListByTeam();
  MatchListByTeam matches = MatchListByTeam();

  @override
  void initState() {
    super.initState();
    Request.getTeamDetails((widget.team_id).toString(), (widget.event_old.id).toString())
        .then((value) {
      if (this.mounted) {
        setState(() {
          _team = value[0];
          team = value[0];
          _matches = value[1];
          matches = value[1];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List list;
    final getTeamDetailsThrottled = throttle(
      () async => {
        list = await Request.getTeamDetails(
            (widget.team_id).toString(), (widget.event_old.id).toString()),
        if (this.mounted)
          {
            setState(() {
              _team = list[0];
              team = list[0];
              _matches = list[1];
              matches = list[1];
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
            icon: const Icon(Icons.star_border_outlined),
            onPressed: () {
              // TODO: Add favorite code
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
          : RefreshIndicator(
              child: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(4),
                  child: Flex(direction: Axis.vertical, children: [
                    ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            team.number.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Text(
                          "Name: ${team.teamName.toString()}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          "Organization: ${team.organization.toString()}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          "Location: ${team.location?.city.toString()}, ${team.location?.region.toString()}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          "Grade: ${team.grade.toString()}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    )
                  ]),
                ),
                if (matches.data != null)
                  for (var i = 0; i <= (((matches.data?.length ?? 1) - 1)); i++)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => MatchPage(
                                  title: (matches.data?[i].name).toString(),
                                  event_old: widget.event_old,
                                  match_number: i)),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        margin: const EdgeInsets.all(4),
                        child: Center(
                          child: Text((matches.data?[i].name).toString()),
                        ),
                      ),
                    ),
              ]),
              onRefresh: () async {
                await getTeamDetailsThrottled();
              },
            ),
    );
  }
}
