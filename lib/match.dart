import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:vrc_ranks_app/Schema/Division.dart' as Div;
import 'package:vrc_ranks_app/Schema/Events.dart';
import 'package:vrc_ranks_app/team.dart';
import 'Request.dart' as Request;
import 'package:collection/collection.dart';

class MatchPage extends StatefulWidget {
  const MatchPage(
      {Key? key,
      required this.title,
      required this.event_old,
      required this.match_number,
      required this.division})
      : super(key: key);

  final String title;
  final Event event_old;
  final int match_number;
  final int division;

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
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
      const Duration(seconds: 0),
    );

    Div.Data? match = (event.divisions?[widget.division].data?.data
        ?.firstWhereOrNull((element) => element.id == widget.match_number));

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: (event.divisions?[widget.division].data?.data).toString() == "null"
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
                                if (match.division != null)
                                  Text(
                                    "Division: ${event.divisions?[widget.division].name.toString()}",
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
                                  "Scored: ${(!(((match.alliances?[0].score ?? 0) & (match.alliances?[0].score ?? 0)) == 0)) ? "Yes" : "No"}",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            if (!(((match.alliances?[0].score ?? 0) &
                                    (match.alliances?[0].score ?? 0)) ==
                                0))
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 25.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: match.alliances?[0].score.toString() ?? "",
                                        style: const TextStyle(color: Colors.blue)),
                                    TextSpan(
                                      text: " - ",
                                      style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyLarge?.color),
                                    ),
                                    TextSpan(
                                        text: match.alliances?[1].score.toString() ?? "",
                                        style: const TextStyle(color: Colors.red)),
                                  ],
                                ),
                              )
                          ]),
                        ),
                        if (event.divisions != null)
                          if (match.alliances?.length != null)
                            for (var prop in (match.alliances!))
                              if (prop.teams != null)
                                for (var prop2 in prop.teams!)
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => TeamPage(
                                                title: (prop2.team?.name).toString(),
                                                match_id: event.id.toString(),
                                                event_old: event,
                                                team_id: (prop2.team?.id).toString())),
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
