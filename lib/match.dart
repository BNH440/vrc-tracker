import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'Hive/Event.dart' as hive_event;
import 'package:vrc_ranks_app/team.dart';
import 'Request.dart' as Request;
import 'Hive/Event.dart' as hiveEvent;

class MatchPage extends StatefulWidget {
  const MatchPage(
      {Key? key,
      required this.title,
      required this.event_old,
      required this.match_number,
      required this.division})
      : super(key: key);

  final String title;
  final String eventId;
  final int divId;
  final hiveEvent.Event event_old;
  final int match_number;
  final int division;

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  hive_event.Event event = hive_event.Event.empty();
  bool initialLoading = true;
  bool predictionLoading = false;

  // @override
  // void initState() {
  //   super.initState();

  //   Request.getEventDetails(widget.event_old.id.toString()).then((value) {
  //     if (this.mounted) {
  //       setState(() {
  //         _event = value;
  //         event = value;
  //       });
  //     }
  //   });
  // }

  late Timer timer;

  @override
  void initState() {
    Request.updateHiveEventDetails(widget.eventId).then((value) => {
          if (this.mounted)
            {
              setState(() {
                initialLoading = false;
              })
            }
        }); // TODO Need this to update event on page load (this comment was copied from event.dart)

    Hive.box<hive_event.Event>('events').watch(key: widget.eventId).listen((listenerEvent) => {
          // listen for changes to event in hive db and set state when those changes occur
          if (this.mounted)
            {
              setState(() {
                log("event changed");
                event = listenerEvent.value as hive_event.Event;
              })
            }
        });

    timer = Timer.periodic(const Duration(seconds: 15), (t) {
      // Update event every 15 seconds
      Request.updateHiveEventDetails(widget.eventId);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final getEventDetailsThrottled = throttle(
      () => {
        Request.updateHiveEventDetails(widget.eventId),
      },
      const Duration(seconds: 0),
    );

    hiveEvent.Match? match = event.divisions?[widget.divId].matches
        ?.firstWhere((match) => match.matchnum == widget.match_number);

    void predictScore() {
      if (match?.redAlliance == null || match?.blueAlliance == null) return;
      setState(() {
        predictionLoading = true;
      });
      Request.predictMatch(
              match!.redAlliance.teams[0].number,
              match.redAlliance.teams[1].number,
              match.blueAlliance.teams[0].number,
              match.blueAlliance.teams[1].number,
              match.id.toString())
          .then((probability) => {
                if (probability != -1.00)
                  {
                    setState(() {
                      predictionLoading = false;
                    }),
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Predicted Win %"),
                            content: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 25.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "${(100 - probability).toStringAsFixed(2)}%",
                                      style: const TextStyle(color: Colors.blue)),
                                  TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color),
                                  ),
                                  TextSpan(
                                      text: "${probability.toStringAsFixed(2)}%",
                                      style: const TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("Close"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        })
                  }
              });
    }

    Widget teamList() {
      return ListView(children: [
            for (var team in alliance.teams) // TODO https://vrc-tracker.atlassian.net/browse/VT-103?focusedCommentId=10170
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => TeamPage(
                            title: (prop2.team?.name).toString(),
                            oldEvent: widget
                                .event_old, // TODO this used to be the main event, replace it with that after converting this page
                            teamId: (prop2.team?.id).toString())),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).cardColor,
                    border: Border.all(
                      color: prop.color == 'red'
                          ? Colors.red
                          : prop.color == 'blue'
                              ? Colors.blue
                              : Colors.grey,
                      width: 1,
                    ),
                  ),
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  margin: const EdgeInsets.all(4),
                  child: Center(
                    child: Text((prop2.team?.name).toString()),
                  ),
                ),
              ),
      ]);
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: (event.divisions?[widget.divId]).toString() == "null"
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
                child: match == null
                    ? const Center(child: Text("Match not found"))
                    : ListView(padding: const EdgeInsets.all(8), children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).cardColor,
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    match.name.toString(),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                if (match.divisionId != null)
                                  Text(
                                    "Division: ${event.divisions?[match.divisionId].name.toString()}", // TODO check if divisionId is an index or an id...
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                if (match.field.toString() != "null")
                                  Text(
                                    "Field: ${match.field.toString()}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                if (match.scheduled.toString() != "null")
                                  Text(
                                    "Scheduled: ${DateFormat.jm().format(DateTime.parse(match.scheduled.toString()).toLocal())}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                Text(
                                  "Scored: ${(!(((match.blueAlliance.score ?? 0) & (match.redAlliance.score ?? 0)) == 0)) ? "Yes" : "No"}",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            !(((match.blueAlliance.score ?? 0) & (match.redAlliance.score ?? 0)) ==
                                    0)
                                ? RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 25.0,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: match.blueAlliance.score.toString() ?? "",
                                            style: const TextStyle(color: Colors.blue)),
                                        TextSpan(
                                          text: " - ",
                                          style: TextStyle(
                                              color: Theme.of(context).textTheme.bodyLarge?.color),
                                        ),
                                        TextSpan(
                                            text: match.redAlliance.score.toString() ?? "",
                                            style: const TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  )
                                : (predictionLoading
                                    ? const Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: CircularProgressIndicator())
                                    : ElevatedButton(
                                        onPressed: predictScore,
                                        child: const Text("Predict Score"))),
                          ]),
                        ),
                        if (event.divisions != null)
                          // if (match.blueAlliance != null && match.redAlliance != null)
                          for (var alliance in (match.alliances!))
                            if (prop.teams != null)
                              for (var prop2 in prop.teams!)
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => TeamPage(
                                              title: (prop2.team?.name).toString(),
                                              oldEvent: widget
                                                  .event_old, // TODO this used to be the main event, replace it with that after converting this page
                                              teamId: (prop2.team?.id).toString())),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).cardColor,
                                      border: Border.all(
                                        color: prop.color == 'red'
                                            ? Colors.red
                                            : prop.color == 'blue'
                                                ? Colors.blue
                                                : Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    margin: const EdgeInsets.all(4),
                                    child: Center(
                                      child: Text((prop2.team?.name).toString()),
                                    ),
                                  ),
                                ),
                      ]),
                onRefresh: () async {
                  await getEventDetailsThrottled();
                }),
      ),
    );
  }
}
