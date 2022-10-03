import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_limiter/rate_limiter.dart';
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
  List<Event> favoritesTeams = [];
  List<Event> favoriteCompsDetails = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteComps = ref.watch(favoriteCompsProvider);
    final favoriteTeams = ref.watch(favoriteTeamsProvider);

    Event currentEvent;

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
    return favoriteComps.isEmpty
        ? const Text("No favorites found")
        : RefreshIndicator(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Text(favoriteComps.toString()),
                Text(favoriteTeams.toString()),
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
                        color: Colors.grey[300],
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
              ],
            ),
            onRefresh: () async {
              await getEventDetailsThrottled();
            },
          );
  }
}
