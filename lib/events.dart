import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'Schema/Events.dart';
import 'event.dart';
import 'Request.dart' as Request;
import 'package:fuzzy/fuzzy.dart';

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
  void getEvents() {
    Request.getEventList(selectedDate).then((value) {
      if (this.mounted) {
        setState(() {
          _events = value;
          events = value;
          filterSearchResults("");
        });
      }
    });
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _events.data = null;
        events.data = null;
      });
      getEvents();
    }
  }

  Events _events = Events();

  Events events = Events();

  List<Event> favoritesEvents = [];
  List<Event> favoritesTeams = [];

  void filterSearchResults(String query) {
    if (_events.data != null) {
      List<Event> searchList = <Event>[];
      searchList.addAll(_events.data!);
      if (query.isNotEmpty) {
        List<Event> dummyListData = <Event>[];

        var fuse = Fuzzy(searchList.map((e) => e.name).toList());

        var nameToIndexMap =
            Map.fromEntries(searchList.map((e) => MapEntry(e.name, searchList.indexOf(e))));

        var result = fuse.search(query);

        dummyListData.addAll(result.map((e) => searchList[nameToIndexMap[e.item]!]).toList());

        setState(() {
          items.clear();
          items.addAll(dummyListData);
        });
        return;
      } else {
        setState(() {
          items.clear();
          items.addAll(_events.data!);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final value = ref.read(favoriteCompsProvider);
    Request.getEventList(selectedDate).then((value) {
      if (this.mounted) {
        setState(() {
          _events = value;
          events = value;
          filterSearchResults("");
        });
      }
    });
  }

  var items = <Event>[];

  @override
  Widget build(BuildContext context) {
    final favoriteComps = ref.watch(favoriteCompsProvider);
    final favoriteTeams = ref.watch(favoriteTeamsProvider);

    final getEventsThrottled = throttle(
      () async => {
        events = await Request.getEventList(selectedDate),
        if (this.mounted)
          {
            setState(() {
              _events = events;
              events = events;
              filterSearchResults("");
            }),
          },
      },
      const Duration(seconds: 0),
    );

    final printThrottled = throttle(
      () => log('throttled'),
      const Duration(seconds: 0),
    );

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: (_events.data).toString() == "null"
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
                  Flex(direction: Axis.horizontal, children: [
                    Expanded(
                      flex: 6,
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(DateFormat.yMMMd().format(selectedDate)),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 10,
                      child: TextField(
                        onChanged: (value) {
                          filterSearchResults(value);
                        },
                        decoration: InputDecoration(
                            labelText: "Search",
                            labelStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                            prefixIcon: const Icon(Icons.search),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                      ),
                    ),
                  ]),
                  if (_events.data != null)
                    if (items.where((element) => element.isLocal).isNotEmpty)
                      Container(
                        margin: const EdgeInsets.all(4),
                        child: RichText(
                            text: const TextSpan(
                                text: "Nearby Events", style: TextStyle(fontSize: 20))),
                      ),
                  for (var event in items.where((element) => element.isLocal))
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
                  if (items.where((element) => element.isLocal).length > 0) const Divider(),
                  Container(
                    margin: const EdgeInsets.all(4),
                    child: RichText(
                        text: const TextSpan(text: "All Events", style: TextStyle(fontSize: 20))),
                  ),
                  for (var event in items.where((element) => element.isLocal == false))
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
            ),
    );
  }
}
