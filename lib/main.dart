import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:dart_date/dart_date.dart';

import 'Schema/Events.dart';
import 'event.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'VEX Ranks App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Events _events = Events();

  Events events = Events();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final utc = "${DateTime.now().format("yyyy-MM-dd")}T00:00:00Z";

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
    };

    Requests.get(
            "https://www.robotevents.com/api/v2/events?season[]=173&start=$utc",
            headers: headers)
        .then((value) => {
              events = Events.fromJson(jsonDecode(value.body)),
              if (this.mounted)
                {
                  setState(() {
                    _events = events;
                  })
                }
            }); // TODO: make event data state for whole app
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          if (_events.data != null)
            for (var event in _events.data!)
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventPage(
                            title: (event.name).toString(), event_old: event)),
                  );
                },
                child: Container(
                  height: 50,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.all(4),
                  child: Center(child: Text((event.name).toString())),
                ),
              ),
        ],
      ),
    );
  }
}
