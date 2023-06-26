import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:vrc_ranks_app/Schema/Team.dart';
import 'package:vrc_ranks_app/event.dart';
import 'package:vrc_ranks_app/teamEvents.dart';
import 'Schema/Events.dart';
import 'events.dart';
import 'Request.dart' as Request;

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  List<Event> favoritesEvents = [];
  List<Team> favoritesTeams = [];
  List<Event> favoriteCompsDetails = [];
  List<Team> favoriteTeamsDetails = [];

  @override
  void initState() {
    super.initState();

    final favoriteComps = ref.read(favoriteCompsProvider);
    final favoriteTeams = ref.read(favoriteTeamsProvider);

    Event currentEvent;
    Team currentTeam;

    favoriteCompsDetails.clear();
    for (var event in favoriteComps) {
      log("Getting event details for ${event.toString()}");
      Request.getEventDetails(event).then((val) => {
            if (mounted)
              {
                setState(() {
                  favoriteCompsDetails.add(val);
                }),
              }
          });
    }

    favoriteTeamsDetails.clear();
    for (var team in favoriteTeams) {
      log("Getting team details for ${team.toString()}");
      Request.getTeam(team.toString()).then((val) => {
            if (this.mounted)
              {
                setState(() {
                  favoriteTeamsDetails.add(val);
                }),
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteComps = ref.watch(favoriteCompsProvider);
    final favoriteTeams = ref.watch(favoriteTeamsProvider);

    Event currentEvent;
    Team currentTeam;

    final getEventDetailsThrottled = throttle(
      () async => {
        favoriteCompsDetails.clear(),
        for (var event in favoriteComps)
          {
            log("Getting event details for ${event.toString()}"),
            currentEvent = await Request.getEventDetails(event),
            if (this.mounted)
              {
                setState(() {
                  favoriteCompsDetails.add(currentEvent);
                })
              }
          }
      },
      const Duration(seconds: 0),
    );
    final getTeamDetailsThrottled = throttle(
      () async => {
        favoriteTeamsDetails.clear(),
        for (var team in favoriteTeams)
          {
            log("Getting team details for ${team.toString()}"),
            currentTeam = await Request.getTeam(team.toString()),
            if (this.mounted)
              {
                setState(() {
                  favoriteTeamsDetails.add(currentTeam);
                })
              }
          }
      },
      const Duration(seconds: 0),
    );

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: favoriteComps.isEmpty && favoriteTeams.isEmpty
          ? const Text("No favorites found")
          : favoriteCompsDetails.isEmpty && favoriteTeamsDetails.isEmpty
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
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      if (favoriteCompsDetails.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.all(4),
                          child: RichText(
                              text: TextSpan(
                                  text: "Events",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).textTheme.bodyMedium?.color))),
                        ),
                      for (var event in favoriteCompsDetails)
                        if (event.name != null)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => EventPage(
                                        title: (event.name).toString(), event_old: event)),
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
                                  (event.name).toString(),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            ),
                          ),
                      if (favoriteTeamsDetails.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.all(4),
                          child: RichText(
                              text: TextSpan(
                                  text: "Teams",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).textTheme.bodyMedium?.color))),
                        ),
                      for (var team in favoriteTeamsDetails)
                        if (team.number != null)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => TeamEventsPage(
                                        title: (team.number).toString(), team_id: team.id ?? 0)),
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
                                              (team.number).toString(),
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (team.organization != null)
                                    Flexible(
                                      child: Text(
                                        (team.organization).toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).colorScheme.tertiary),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                  onRefresh: () async {
                    await getEventDetailsThrottled();
                    await getTeamDetailsThrottled();
                  },
                ),
    );
  }
}
