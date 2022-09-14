import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:vrc_ranks_app/Schema/Events.dart';
import 'Request.dart' as Request;
import 'match.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String convertDate(String date) {
    var humanDate = DateTime.parse(date);

    return DateFormat("MMM dd, yyyy").format(humanDate);
  }

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
        title: Text(widget.title,
            style: const TextStyle(
              overflow: TextOverflow.fade,
            )),
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
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(4),
                    child: Flex(direction: Axis.vertical, children: [
                      ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                event.name.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                "${convertDate(event.start.toString())} - ${convertDate(event.end.toString())}",
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            Text(
                              "Ongoing: ${event.ongoing.toString() == "true" ? "Yes" : "No"}",
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              "Competition: ${event.season?.name.toString()}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ]),
                      Align(
                          alignment: FractionalOffset.bottomRight,
                          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    print("Redirect to navigation app");
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[400],
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    child: const Icon(Icons.navigation_rounded, size: 30),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    launchUrl(Uri.parse(
                                        "https://www.robotevents.com/robot-competitions/vex-robotics-competition/${event.sku}.html"));
                                    print("Redirect to web browser with comp link");
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[400],
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: const Icon(Icons.link, size: 30),
                                  ),
                                ),
                              ],
                            ),
                          ]))
                    ])),
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
