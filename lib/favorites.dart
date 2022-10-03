import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:vrc_ranks_app/Schema/Team.dart';
import 'package:vrc_ranks_app/event.dart';
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
      const Duration(seconds: 2),
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
      const Duration(seconds: 2),
    );

    return favoriteComps.isEmpty && favoriteTeams.isEmpty
        ? const Text("No favorites found")
        : RefreshIndicator(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                for (var event in favoriteCompsDetails)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                EventPage(title: (event.name).toString(), event_old: event)),
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
                for (var team in favoriteTeamsDetails)
                  InkWell(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(
                    //         builder: (context) =>
                    //             EventPage(title: (event.name).toString(), event_old: event)),
                    //   );
                    // },
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
                          (team.number).toString(),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onRefresh: () async {
              await getEventDetailsThrottled();
              await getTeamDetailsThrottled();
            },
          );
  }
}
