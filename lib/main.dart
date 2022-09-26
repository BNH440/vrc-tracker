import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'Schema/Events.dart';
import 'event.dart';
import 'Request.dart' as Request;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VEX Ranks App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'VEX Ranks App'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final favoriteCompsProvider = StateProvider<List<String>>((ref) {
  return [];
});

final favoriteTeamsProvider = StateProvider<List<String>>((ref) {
  return [];
});

class _MyHomePageState extends ConsumerState<MyHomePage> {
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
    // final favorites = Provider.of<Favorites>(context);
    final favoriteComps = ref.watch(favoriteCompsProvider);
    final favoriteTeams = ref.watch(favoriteTeamsProvider);

    // TODO: LOOP INSIDE BUILD METHOD REMOVE!!!!!!!!!!
    // for (var comp in favorites) {
    //   Request.getEventDetails(comp.toString()).then((value) => {
    //         if (this.mounted)
    //           {
    //             setState(() {
    //               var newFavoritesEvents = favoritesEvents;
    //               newFavoritesEvents.add(value);
    //               favoritesEvents = newFavoritesEvents;
    //             }),
    //           },
    //       });
    // }

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

    int _selectedIndex = 0;
    const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.numbers),
            label: 'Rankings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: (_events.data).toString() == "null"
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
                  // Text(favorites.favoriteComps.isEmpty
                  //     ? "None"
                  //     : favorites.favoriteComps.toString()),
                  Text(favoriteComps.toString()),
                  Text(favoriteTeams.toString()),

                  // return Text(favorites.favoriteComps.elementAt(0).toString() ?? "No favorites");

                  // if(favoritesEvents.isNotEmpty)
                  //   for (var comp in favoritesEvents)
                  //     Stack(
                  //       children: [
                  //         Card(
                  //           child: ListTile(
                  //             title: Text(comp.name.toString()),
                  //             onTap: () {
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) => EventPage(
                  //                     title: comp.name.toString(),
                  //                     event_old: comp,
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  //     );

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
                await getEventsThrottled();
              },
            ),
    );
  }
}
