import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:vrc_ranks_app/Schema/Events.dart';
import 'package:vrc_ranks_app/team.dart';
import 'Request.dart' as Request;

class MatchPage extends StatefulWidget {
  const MatchPage(
      {Key? key, required this.title, required this.event_old, required this.match_number})
      : super(key: key);

  final String title;
  final Event event_old;
  final int match_number;

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
      const Duration(seconds: 2),
    );

    var match = (event.divisions?[0].data?.data?.singleWhere(
        (element) => element.id == widget.match_number,
        orElse: () => event.divisions![0].data!.data![0]));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (match).toString() == "null"
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
              child: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
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
                            match!.name.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Text(
                          "Field: ${match.field.toString()}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          "Scheduled: ${DateFormat.jm().format(DateTime.parse(match.scheduled.toString()))}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        if (match.started != null)
                          Text(
                            "Started: ${DateFormat.jm().format(DateTime.parse(match.started.toString()))}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        Text(
                          "Scored: ${match.scored.toString() == "true" ? "No" : "Yes"}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    if (!(match.scored ?? true))
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
                              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
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
    );
  }
}
