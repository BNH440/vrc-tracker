import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrc_ranks_app/events.dart';
import 'package:vrc_ranks_app/teamEvents.dart';
import 'Request.dart' as Request;
import 'match.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'Hive/Event.dart';
import 'Hive/Team.dart';

class TeamPage extends ConsumerStatefulWidget {
  const TeamPage({Key? key, required this.title, required this.teamId, required this.oldEvent})
      : super(key: key);

  final String title;
  final String teamId;
  final Event oldEvent;

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage> {
  late Event event;
  Team? team;
  late int teamDiv;
  List<Match> matches = [];
  List<Rank>? rankings = [];
  int division = 0;

  late Timer timer;

  @override
  void initState() {
    event = widget.oldEvent;
    teamDiv = event.divisions?.indexWhere((element) =>
            element.rankings
                ?.any((team) => team.team.first.id.toString() == widget.teamId.toString()) ??
            false) ??
        -1;
    log(teamDiv.toString());
    super.initState();

    Request.updateHiveEventDetails(event.id.toString());

    Hive.box<Event>('events').watch(key: event.id.toString()).listen((listenerEvent) => {
          // listen for changes to event in hive db and set state when those changes occur
          if (this.mounted)
            {
              setState(() {
                log("event changed");
                event = listenerEvent.value as Event;
                matches = event.divisions?[teamDiv].matches ?? [];
              })
            }
        });

    timer = Timer.periodic(const Duration(seconds: 15), (t) {
      // Update event every 15 seconds
      Request.updateHiveEventDetails(event.id.toString());
    });

    final favoriteTeams = ref.read(favoriteTeamsProvider);

    Request.getTeam((widget.teamId).toString()).then((value) {
      if (mounted) {
        setState(() {
          team = value;
        });
      }
    });

    //   Request.getTeamDetails((widget.teamId).toString(), (widget.event_old.id).toString())
    //       .then((value) {
    //     if (this.mounted) {
    //       setState(() {
    //         team = value[0];
    //         matches = value[1];

    //         division = matches.data?.isNotEmpty ?? false
    //             ? widget.event_old.divisions
    //                     ?.firstWhereOrNull((element) =>
    //                         element.id.toString() == matches.data?[0].division?.id.toString())
    //                     ?.order ??
    //                 -1
    //             : -1;

    //         if (division != -1) {
    //           rankings = widget.event_old.divisions?[division].rankings;
    //         }
    //       });
    //     }
    //   });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteTeams = ref.watch(favoriteTeamsProvider);

    final refreshDetails = throttle(
      () async => {
        Request.updateHiveEventDetails(event.id.toString()),
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
              icon: ref.read(favoriteTeamsProvider.notifier).state.contains(team?.id.toString())
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_border_outlined),
              onPressed: () {
                List<String> oldState = ref.read(favoriteTeamsProvider.notifier).state;
                if (oldState.contains(team?.id.toString())) {
                  oldState.remove(team?.id.toString());
                } else {
                  oldState.add(team!.id.toString());
                }
                ref.read(favoriteTeamsProvider.notifier).update((state) => oldState.toList());

                SharedPreferences.getInstance()
                    .then((prefs) => prefs.setStringList('favoriteTeams', oldState.toList()));
              },
            ),
          ],
        ),
        body: matches.isEmpty
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
                              team?.number.toString() ?? "",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Text(
                            "Name: ${team?.teamName.toString()}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Organization: ${team?.organization.toString()}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Location: ${team?.location?.city.toString()}, ${(team?.location?.region ?? team?.location?.country).toString()}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Grade: ${team?.grade.toString()}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          if (rankings?.isNotEmpty ?? false)
                            if (division != -1)
                              MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: 1.0)
                                    .removePadding(removeTop: true, removeBottom: true),
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    const Text(""),
                                    Text(
                                      // "Division: ${rankings?.firstWhereOrNull((element) => element.team.single.id == team.id)?.division?.name.toString()}", // TODO add division name string in class
                                      "Division: FIX THIS", // TODO add division name string in class
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Rank: ${rankings?.firstWhereOrNull((element) => element.team.single.id == team?.id)?.rank.toString()}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Record: ${rankings?.firstWhereOrNull((element) => element.team.single.id == team?.id)?.wins.toString()}-${rankings?.firstWhereOrNull((element) => element.team.single.id == team?.id)?.losses.toString()}-${rankings?.firstWhereOrNull((element) => element.team.single.id == team?.id)?.ties.toString()}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Avg Points: ${rankings?.firstWhereOrNull((element) => element.team.single.id == team?.id)?.averagePoints.toString()}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "High Score: ${rankings?.firstWhereOrNull((element) => element.team.single.id == team?.id)?.highScore.toString()}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "WP: ${rankings?.firstWhereOrNull((element) => element.team.single.id == team?.id)?.wp.toString()}, AP: ${rankings?.firstWhereOrNull((element) => element.team.single.id == team?.id)?.ap.toString()}, SP: ${rankings?.firstWhereOrNull((element) => element.team.single.id == team?.id)?.sp.toString()}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                          team?.id != null
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints.tightFor(
                                        width: 200,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TeamEventsPage(
                                                      title: team!.teamName.toString(),
                                                      team_id: team!.id,
                                                    )),
                                          );
                                        },
                                        child: const Text('Team Details'),
                                      ),
                                    ),
                                  ),
                                )
                              : const Text(""),
                        ],
                      )
                    ]),
                  ),
                  if (matches.isNotEmpty)
                    for (var i = 0; i <= ((matches.length - 1)); i++)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MatchPage(
                                      title: (matches[i].name).toString(),
                                      event_old: widget.oldEvent,
                                      match_number: matches[i].id,
                                      division: division,
                                    )),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).cardColor,
                          ),
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.all(4),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          (matches[i].name.replaceFirst("Qualifier", "Qual"))
                                              .toString(),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(flex: 2),
                              SizedBox(
                                width: 60,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.tertiary,
                                            fontSize: 14,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: matches[i].blueAlliance.teams[0].number,
                                                style: TextStyle(
                                                    color: (matches[i].blueAlliance.teams[0].id ==
                                                            team?.id)
                                                        ? Colors.blue
                                                        : null)),
                                            TextSpan(
                                                text:
                                                    "\n${matches[i].blueAlliance.teams[1].number}",
                                                style: TextStyle(
                                                    color: (matches[i].blueAlliance.teams[1].id ==
                                                            team?.id)
                                                        ? Colors.blue
                                                        : null)),
                                          ],
                                        ),
                                        textAlign: TextAlign.right)),
                              ),
                              const Spacer(),
                              (matches[i].blueAlliance.score.toString() != "0" ||
                                      matches[i].redAlliance.score.toString() != "0")
                                  ? SizedBox(
                                      width: 100,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                  alignment: PlaceholderAlignment.middle,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style: const TextStyle(
                                                        fontSize: 20.0,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: matches[i]
                                                                .blueAlliance
                                                                .score
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontWeight: (matches[i]
                                                                        .blueAlliance
                                                                        .teams
                                                                        .any((element) =>
                                                                            element.id == team?.id))
                                                                    ? FontWeight.bold
                                                                    : FontWeight.normal)),
                                                        TextSpan(
                                                          text: " - ",
                                                          style: TextStyle(
                                                              color: Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color),
                                                        ),
                                                        TextSpan(
                                                            text: matches[i]
                                                                .redAlliance
                                                                .score
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors.red,
                                                                fontWeight: (matches[i]
                                                                        .redAlliance
                                                                        .teams
                                                                        .any((element) =>
                                                                            element.id == team?.id))
                                                                    ? FontWeight.bold
                                                                    : FontWeight.normal)),
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Text(((matches[i].scheduled ?? "").isNotEmpty
                                      ? DateFormat.jm().format(
                                          DateTime.parse((matches[i].scheduled).toString())
                                              .toLocal())
                                      : "N/A")),
                              const Spacer(),
                              SizedBox(
                                width: 60,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.tertiary,
                                          fontSize: 14,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: matches[i].redAlliance.teams[0].number,
                                              style: TextStyle(
                                                  color: (matches[i].redAlliance.teams[0].id ==
                                                          team?.id)
                                                      ? Colors.red
                                                      : null)),
                                          TextSpan(
                                              text: "\n${matches[i].redAlliance.teams[1].number}",
                                              style: TextStyle(
                                                  color: (matches[i].redAlliance.teams[1].id ==
                                                          team?.id)
                                                      ? Colors.red
                                                      : null)),
                                        ],
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                ]),
                onRefresh: () async {
                  await refreshDetails();
                },
              ),
      ),
    );
  }
}
