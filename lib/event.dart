import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:vrc_ranks_app/Schema/Events.dart';
import 'Request.dart' as Request;
import 'match.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key, required this.title, required this.event_old}) : super(key: key);

  final String title;
  final Event event_old;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Event _event = Event();
  Event event = Event();

  @override
  void initState() {
    super.initState();
    Request.getEventDetails(widget.event_old.id.toString()).then((value) {
      if (this.mounted) {
        setState(() {
          _event = value;
          event = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final getEventDetailsThrottled = throttle(
      () async => {
        event = await Request.getEventDetails(widget.event_old.id.toString()),
        if (this.mounted)
          {
            setState(() {
              _event = event;
              event = event;
            }),
          },
      },
      const Duration(seconds: 2),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              getEventDetailsThrottled();
            },
          ),
        ],
      ),
      body: (event.divisions?[0].data?.data).toString() == "null"
          ? const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  height: 200,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(4),
                  child: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
                    Text(
                      event.name.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Ongoing: ${event.ongoing.toString() == "true" ? "Yes" : "No"}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      "Address: ${event.location?.address1.toString()}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Align(
                      alignment: FractionalOffset.bottomRight,
                      child: InkWell(
                        onTap: () {
                          print("Redirect to navigation app");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[400],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.navigation_rounded, size: 30),
                        ),
                      ),
                    ),
                  ]),
                ),
                for (var i = 0; i <= (((event.divisions?[0].data?.data?.length ?? 1) - 1)); i++)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => MatchPage(
                                title: (event.divisions?[0].data?.data?[i].name).toString(),
                                event_old: event,
                                match_number: i)),
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
                        child: Text((event.divisions?[0].data?.data?[i].name).toString()),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
