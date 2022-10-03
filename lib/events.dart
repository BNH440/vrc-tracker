import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'Schema/Events.dart';
import 'event.dart';
import 'Request.dart' as Request;

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _EventsPageState createState() => _EventsPageState();
}

final favoriteCompsProvider = StateProvider<List<String>>((ref) {
  return [];
});

final favoriteTeamsProvider = StateProvider<List<String>>((ref) {
  return [];
});

class _EventsPageState extends ConsumerState<EventsPage> {
  Events _events = Events();

  Events events = Events();

  List<Event> favoritesEvents = [];
  List<Event> favoritesTeams = [];

  @override
  void initState() {
    super.initState();
    final value = ref.read(favoriteCompsProvider);
    Request.getEventList().then((value) {
      if (this.mounted) {
        setState(() {
          _events = value;
          events = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteComps = ref.watch(favoriteCompsProvider);
    final favoriteTeams = ref.watch(favoriteTeamsProvider);

    final getEventsThrottled = throttle(
      () async => {
        events = await Request.getEventList(),
        if (this.mounted)
          {
            setState(() {
              _events = events;
              events = events;
            }),
          },
      },
      const Duration(seconds: 1),
    );

    final printThrottled = throttle(
      () => log('throttled'),
      const Duration(seconds: 1),
    );

    const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

    return (_events.data).toString() == "null"
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
                if (_events.data != null)
                  for (var event in _events.data!)
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
              ],
            ),
            onRefresh: () async {
              await getEventsThrottled();
            },
          );
  }
}
