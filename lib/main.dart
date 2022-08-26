import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';

import 'Schema/Events.dart';
import 'event.dart';

import 'Request.dart' as Request;

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

  // final getEventsThrottled = throttle(
  //   () => {
  //     Request.getEventList().then((value) => events = value),
  //   },
  //   const Duration(seconds: 2),
  // );

  @override
  void initState() {
    super.initState();
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
      () => print('throttled'),
      const Duration(seconds: 1),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              getEventsThrottled();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          // Container(
          //   height: 50,
          //   margin: const EdgeInsets.all(4),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       printThrottled();
          //     },
          //     child: const Text('Refresh'),
          //   ),
          // ),
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
