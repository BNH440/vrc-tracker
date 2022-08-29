import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:vrc_ranks_app/Schema/Events.dart';
import 'Request.dart' as Request;

class MatchPage extends StatefulWidget {
  const MatchPage(
      {Key? key, required this.title, required this.event_old, required this.match_number})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

    if (event.divisions != null) {
      for (var i = 0;
          i < (event.divisions?[0].data?.data?[widget.match_number].alliances?.length ?? 1) - 1;
          i++) {
        for (var f = 0;
            f <
                (((event.divisions?[0].data?.data?[widget.match_number].alliances?[i])
                        ?.teams
                        ?.length ??
                    0));
            i++) {
          print((event.divisions?[0].data?.data?[widget.match_number].alliances?[i].teams?[f].team
                  ?.name)
              .toString());
        }
      }
    }

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
      body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        Text((event.divisions?[0].data?.data?[widget.match_number].id).toString()),
        // for (var i = 0;
        //     i <
        //         (event.divisions?[0].data?.data?[widget.match_number].alliances
        //                 ?.length ??
        //             1);
        //     i++)
        //   for (var f = 0;
        //       f <
        //           (((event.divisions?[0].data?.data?[widget.match_number]
        //                       .alliances?[i])
        //                   ?.teams
        //                   ?.length ??
        //               1));
        //       i++)
        //     Text((event.divisions?[0].data?.data?[widget.match_number]
        //             .alliances?[i].teams?[f].team?.name)
        //         .toString()),
      ]),
    );
  }
}
