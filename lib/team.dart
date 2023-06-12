import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrc_ranks_app/Schema/MatchListByTeam.dart';
import 'package:vrc_ranks_app/Schema/Rankings.dart';
import 'package:vrc_ranks_app/Schema/Team.dart';
import 'package:vrc_ranks_app/Schema/Events.dart' as Events;
import 'package:vrc_ranks_app/events.dart';
import 'Request.dart' as Request;
import 'match.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class TeamPage extends ConsumerStatefulWidget {
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
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage> {
  Team _team = Team();
  Team team = Team();
  MatchListByTeam _matches = MatchListByTeam();
  MatchListByTeam matches = MatchListByTeam();
  Rankings? rankings = Rankings();
  int division = 0;

  @override
  void initState() {
    super.initState();
    final favoriteTeams = ref.read(favoriteTeamsProvider);
    Request.getTeamDetails((widget.team_id).toString(), (widget.event_old.id).toString())
        .then((value) {
      if (this.mounted) {
        setState(() {
          _team = value[0];
          team = value[0];
          _matches = value[1];
          matches = value[1];

          division = matches.data?.isNotEmpty ?? false
              ? widget.event_old.divisions
                      ?.firstWhereOrNull((element) =>
                          element.id.toString() == matches.data?[0].division?.id.toString())
                      ?.order ??
                  -1
              : -1;

          if (division != -1) {
            rankings = widget.event_old.divisions?[division].rankings;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteTeams = ref.watch(favoriteTeamsProvider);

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

              division = matches.data?.isNotEmpty ?? false
                  ? widget.event_old.divisions
                          ?.firstWhereOrNull((element) =>
                              element.id.toString() == matches.data?[0].division?.id.toString())
                          ?.order ??
                      -1
                  : -1;

              if (division != -1) {
                rankings = widget.event_old.divisions?[division].rankings;
              }
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
                            "Location: ${team.location?.city.toString()}, ${team.location?.region.toString()}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Grade: ${team.grade.toString()}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          if (rankings?.data != null)
                            if ((rankings?.data!.length)! > 0)
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
                                        "Division: ${rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.division?.name.toString()}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "Rank: ${rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.rank.toString()}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "Record: ${rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.wins.toString()}-${rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.losses.toString()}-${rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.ties.toString()}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "Avg Points: ${rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.averagePoints.toString()}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "High Score: ${rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.highScore.toString()}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "WP: ${rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.wp.toString()}, AP: ${rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.ap.toString()}, SP: ${rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.sp.toString()}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
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
                                      match_number: (matches.data?[i].id ?? 0).toInt(),
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
                                          (matches.data?[i].name?.replaceFirst("Qualifier", "Qual"))
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
                                width: 55,
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
                                              text:
                                                  "${matches.data?[i].alliances?[0].teams?[0].team?.name}",
                                              style: TextStyle(
                                                  color: (matches.data?[i].alliances?[0].teams?[0]
                                                              .team?.id ==
                                                          team.id)
                                                      ? Colors.blue
                                                      : null)),
                                          TextSpan(
                                              text:
                                                  "\n${matches.data?[i].alliances?[0].teams?[1].team?.name}",
                                              style: TextStyle(
                                                  color: (matches.data?[i].alliances?[0].teams?[1]
                                                              .team?.id ==
                                                          team.id)
                                                      ? Colors.blue
                                                      : null)),
                                        ],
                                      ),
                                    )),
                              ),
                              const Spacer(),
                              (matches.data?[i].alliances?[0].score.toString() != "0" ||
                                      matches.data?[i].alliances?[1].score.toString() != "0")
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
                                                            text: matches
                                                                    .data?[i].alliances?[0].score
                                                                    .toString() ??
                                                                "",
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontWeight: (matches.data?[i]
                                                                            .alliances?[0].teams!
                                                                            .any((element) =>
                                                                                element.team?.id ==
                                                                                team.id) ??
                                                                        false)
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
                                                            text: matches
                                                                    .data?[i].alliances?[1].score
                                                                    .toString() ??
                                                                "",
                                                            style: TextStyle(
                                                                color: Colors.red,
                                                                fontWeight: (matches.data?[i]
                                                                            .alliances?[1].teams!
                                                                            .any((element) =>
                                                                                element.team?.id ==
                                                                                team.id) ??
                                                                        false)
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
                                  : Text("N/A"),
                              const Spacer(),
                              SizedBox(
                                width: 55,
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
                                              text:
                                                  "${matches.data?[i].alliances?[1].teams?[0].team?.name}",
                                              style: TextStyle(
                                                  color: (matches.data?[i].alliances?[1].teams?[0]
                                                              .team?.id ==
                                                          team.id)
                                                      ? Colors.red
                                                      : null)),
                                          TextSpan(
                                              text:
                                                  "\n${matches.data?[i].alliances?[1].teams?[1].team?.name}",
                                              style: TextStyle(
                                                  color: (matches.data?[i].alliances?[1].teams?[1]
                                                              .team?.id ==
                                                          team.id)
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
                  await getTeamDetailsThrottled();
                },
              ),
      ),
    );
  }
}
