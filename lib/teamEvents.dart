import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Hive/Team.dart';
import 'package:vrc_ranks_app/event.dart';
import 'package:vrc_ranks_app/events.dart';
import 'Request.dart' as Request;
import 'package:flutter_riverpod/flutter_riverpod.dart';
// TODO left off with this error when you go to the team details page, need to fix team events
class TeamEventsPage extends ConsumerStatefulWidget {
  const TeamEventsPage({Key? key, required this.title, required this.team_id}) : super(key: key);

  final String title;
  final int team_id;

  @override
  _TeamEventsPageState createState() => _TeamEventsPageState();
}

class _TeamEventsPageState extends ConsumerState<TeamEventsPage> {
  late Team team;

  void _getTeamEvents() async {
    Team response = await Request.getTeamEvents(team);
    if (this.mounted) {
      setState(() {
        team = response;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final favoriteTeams = ref.read(favoriteTeamsProvider);
    Request.getTeam((widget.team_id).toString()).then((value) {
      if (mounted) {
        setState(() {
          team = value;
          _getTeamEvents();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteTeams = ref.watch(favoriteTeamsProvider);
    Team response;
    final getTeamDetailsThrottled = throttle(
      () async => {
        response = await Request.getTeam((widget.team_id).toString()),
        if (this.mounted)
          {
            setState(() {
              team = response;
            }),
          },
      },
      const Duration(seconds: 0),
    );

    final getTeamEventsThrottled = throttle(
      () async => {
        response = await Request.getTeamEvents(team),
        if (this.mounted)
          {
            setState(() {
              team = response;
            }),
          },
      },
      const Duration(seconds: 0),
    );

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: ref.read(favoriteTeamsProvider.notifier).state.contains(team.id.toString())
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_border_outlined),
              onPressed: () {
                List<String> oldState = ref.read(favoriteTeamsProvider.notifier).state;
                if (oldState.contains(team.id.toString())) {
                  oldState.remove(team.id.toString());
                } else {
                  oldState.add(team.id.toString());
                }
                ref.read(favoriteTeamsProvider.notifier).update((state) => oldState.toList());

                SharedPreferences.getInstance()
                    .then((prefs) => prefs.setStringList('favoriteTeams', oldState.toList()));
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
                      color: Theme.of(context).cardColor,
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
                            "Location: ${team.location?.city.toString()}, ${(team.location?.region ?? team.location?.country).toString()}",
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
                  team.events != null
                      ? ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                              for (var i = 0; i <= (((team.events?.length ?? 1) - 1)); i++)
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => EventPage(
                                          title: (team.events?[i].name).toString(),
                                          id: team.events![i].id.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    margin: const EdgeInsets.all(4),
                                    child: Center(
                                      child: Text(
                                        (team.events?[i].name).toString(),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                ),
                            ])
                      : const Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          ),
                        )
                ]),
                onRefresh: () async {
                  await getTeamDetailsThrottled();
                  await getTeamEventsThrottled();
                },
              ),
      ),
    );
  }
}
