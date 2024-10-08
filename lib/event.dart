import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrc_ranks_app/Schema/Events.dart';
import 'package:vrc_ranks_app/events.dart';
import 'package:vrc_ranks_app/team.dart';
import 'Request.dart' as Request;
import 'match.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:collection/collection.dart';

class EventPage extends ConsumerStatefulWidget {
  const EventPage({Key? key, required this.title, required this.event_old}) : super(key: key);

  final String title;
  final Event event_old;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends ConsumerState<EventPage> {
  Event _event = Event();
  Event event = Event();
  List<Request.SkillsTotal> _skills = [];
  List<Request.SkillsTotal> skills = [];
  String dropdownValue = 'Division 1';
  List<String> divisions = ["Division 1"];
  int selectedDivison = 0;

  String convertDate(String date) {
    var humanDate = DateTime.parse(date);

    return DateFormat("MMM dd, yyyy").format(humanDate);
  }

  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 15), (t) {
      Request.getEventDetails(widget.event_old.id.toString()).then((value) {
        if (this.mounted) {
          setState(() {
            _event = value;
            event = value;

            divisions = event.divisions!.map((e) => e.name!).toList();
            if (!divisions.contains(dropdownValue)) {
              dropdownValue = divisions[0];
            }
            selectedDivison = divisions.indexOf(dropdownValue);
          });
        }
      });
      Request.getSkills(widget.event_old.id.toString()).then((value) {
        if (this.mounted) {
          setState(() {
            _skills = value;
            skills = value;
          });
        }
      });
    });
    super.initState();
    Request.getEventDetails(widget.event_old.id.toString()).then((value) {
      if (this.mounted) {
        setState(() {
          _event = value;
          event = value;

          divisions = event.divisions!.map((e) => e.name!).toList();
          if (!divisions.contains(dropdownValue)) {
            dropdownValue = divisions[0];
          }
          selectedDivison = divisions.indexOf(dropdownValue);
        });
      }
    });
    Request.getSkills(widget.event_old.id.toString()).then((value) {
      if (this.mounted) {
        setState(() {
          _skills = value;
          skills = value;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteCompsProvider);

    final getEventDetailsThrottled = throttle(
      () async => {
        event = await Request.getEventDetails(widget.event_old.id.toString()),
        if (this.mounted)
          {
            setState(() {
              _event = event;
              event = event;

              divisions = event.divisions!.map((e) => e.name!).toList();
              if (!divisions.contains(dropdownValue)) {
                dropdownValue = divisions[0];
              }
              selectedDivison = divisions.indexOf(dropdownValue);
            }),
          },
        skills = await Request.getSkills(widget.event_old.id.toString()),
        if (this.mounted)
          {
            setState(() {
              _skills = skills;
              skills = skills;
            }),
          },
      },
      const Duration(seconds: 0),
    );

    Widget MatchesTab() {
      return (event.divisions?[0].data?.data).toString() == "null"
          ? const Text("")
          : event.divisions?[0].data == null ||
                  event.divisions?[0].data?.data == null ||
                  event.divisions?[0].data?.data?.isEmpty == true
              ? const Center(child: Text("No matches found"))
              : RefreshIndicator(
                  child: MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaleFactor: 1.0)
                        .removePadding(removeTop: true),
                    child: ListView(children: [
                      divisions.length == 1
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  const Text("Division",
                                      style:
                                          TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      onChanged: (String? value) {
                                        setState(() {
                                          dropdownValue = value!;
                                          selectedDivison = divisions.indexOf(dropdownValue);
                                        });
                                      },
                                      items:
                                          divisions.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              )),
                      if (event.divisions?[selectedDivison].data?.data?.isEmpty ?? true)
                        const Center(
                            heightFactor: 3,
                            child: Text(
                              "No matches found",
                              textAlign: TextAlign.center,
                            )),
                      if (event.divisions?[selectedDivison].data?.data?.isNotEmpty ?? false)
                        for (var i = 0;
                            i <=
                                (((event.divisions?[selectedDivison].data?.data?.length ?? 1) - 1));
                            i++)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => MatchPage(
                                    title: (event.divisions?[selectedDivison].data?.data?[i].name)
                                        .toString(),
                                    event_old: event,
                                    match_number:
                                        (event.divisions?[selectedDivison].data?.data?[i].id ?? 0)
                                            .toInt(),
                                    division: selectedDivison,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).cardColor,
                              ),
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              margin: const EdgeInsets.all(4),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            alignment: PlaceholderAlignment.middle,
                                            child: Text(
                                              (event.divisions?[selectedDivison].data?.data?[i].name
                                                      ?.replaceFirst("Qualifier", "Qual"))
                                                  .toString(),
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(flex: 2),
                                  SizedBox(
                                    width: 60,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              alignment: PlaceholderAlignment.middle,
                                              child: Text(
                                                "${event.divisions?[selectedDivison].data?.data?[i].alliances?[0].teams?[0].team?.name}\n${event.divisions?[selectedDivison].data?.data?[i].alliances?[0].teams?[1].team?.name}",
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.tertiary,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  (event.divisions?[selectedDivison].data?.data?[i].alliances?[0]
                                                  .score
                                                  .toString() !=
                                              "0" ||
                                          event.divisions?[selectedDivison].data?.data?[i]
                                                  .alliances?[1].score
                                                  .toString() !=
                                              "0")
                                      ? SizedBox(
                                          width: 100,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                      alignment: PlaceholderAlignment.middle,
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style: const TextStyle(
                                                            fontSize: 20.0,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: event
                                                                        .divisions?[selectedDivison]
                                                                        .data
                                                                        ?.data?[i]
                                                                        .alliances?[0]
                                                                        .score
                                                                        .toString() ??
                                                                    "",
                                                                style: const TextStyle(
                                                                    color: Colors.blue)),
                                                            TextSpan(
                                                              text: " - ",
                                                              style: TextStyle(
                                                                  color: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyLarge
                                                                      ?.color),
                                                            ),
                                                            TextSpan(
                                                                text: event
                                                                        .divisions?[selectedDivison]
                                                                        .data
                                                                        ?.data?[i]
                                                                        .alliances?[1]
                                                                        .score
                                                                        .toString() ??
                                                                    "",
                                                                style: const TextStyle(
                                                                    color: Colors.red)),
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text(((event.divisions?[selectedDivison].data?.data?[i]
                                                      .scheduled ??
                                                  "")
                                              .isNotEmpty
                                          ? DateFormat.jm().format(DateTime.parse((event
                                                      .divisions?[selectedDivison]
                                                      .data
                                                      ?.data?[i]
                                                      .scheduled)
                                                  .toString())
                                              .toLocal())
                                          : "N/A")),
                                  const Spacer(),
                                  SizedBox(
                                    width: 60,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              alignment: PlaceholderAlignment.middle,
                                              child: Text(
                                                "${event.divisions?[selectedDivison].data?.data?[i].alliances?[1].teams?[0].team?.name}\n${event.divisions?[selectedDivison].data?.data?[i].alliances?[1].teams?[1].team?.name}",
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.tertiary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                    ]),
                  ),
                  onRefresh: () async {
                    await getEventDetailsThrottled();
                  },
                );
    }

    Widget TeamsTab() {
      return (event.teams?.data).toString() == "null"
          ? const Text("")
          : event.teams == null ||
                  event.teams?.data == null ||
                  event.teams?.data?.isEmpty == true ||
                  (event.divisions?[0].rankings?.data?.isEmpty ?? true)
              ? const Center(child: Text("No teams found"))
              : RefreshIndicator(
                  child: MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaleFactor: 1.0)
                        .removePadding(removeTop: true),
                    child: ListView(children: [
                      divisions.length == 1
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  const Text("Division",
                                      style:
                                          TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      onChanged: (String? value) {
                                        setState(() {
                                          dropdownValue = value!;
                                          selectedDivison = divisions.indexOf(dropdownValue);
                                        });
                                      },
                                      items:
                                          divisions.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              )),
                      if (event.divisions?[selectedDivison].rankings?.data?.isEmpty ?? true)
                        const Center(
                            heightFactor: 3,
                            child: Text(
                              "No teams found\nNote: Finals divisions will not have teams",
                              textAlign: TextAlign.center,
                            )),
                      if (event.divisions?[selectedDivison].rankings?.data?.isNotEmpty ?? false)
                        for (var team in (event.teams!.data!.where((element) =>
                            event.divisions![selectedDivison].rankings!.data!
                                .firstWhereOrNull((element2) => element2.team!.id == element.id) !=
                            null)))
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => TeamPage(
                                      title: (team.number).toString(),
                                      event_old: event,
                                      match_id: event.id.toString(),
                                      team_id: (team.id).toString()),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).cardColor,
                              ),
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              margin: const EdgeInsets.all(4),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            alignment: PlaceholderAlignment.middle,
                                            child: Text(
                                              (team.number).toString(),
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (team.teamName != null)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        width: 160,
                                        child: Text(
                                          (team.teamName).toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context).colorScheme.tertiary),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  const Spacer(flex: 5),
                                  if (event.divisions?[selectedDivison].rankings?.data != null)
                                    if ((event.divisions?[selectedDivison].rankings?.data?.length ??
                                            0) >
                                        0)
                                      if (event.divisions?[selectedDivison].rankings?.data
                                              ?.firstWhereOrNull(
                                                  (element) => element.team?.id == team.id)
                                              .toString() !=
                                          "null")
                                        SizedBox(
                                          width: 60,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    alignment: PlaceholderAlignment.middle,
                                                    child: Text(
                                                      "Rank: ${event.divisions?[selectedDivison].rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.rank.toString()}      ${event.divisions?[selectedDivison].rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.wins.toString()}-${event.divisions?[selectedDivison].rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.losses.toString()}-${event.divisions?[selectedDivison].rankings?.data?.firstWhereOrNull((element) => element.team?.id == team.id)?.ties.toString()}",
                                                      style: TextStyle(
                                                        color:
                                                            Theme.of(context).colorScheme.tertiary,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                    ]),
                  ),
                  onRefresh: () async {
                    await getEventDetailsThrottled();
                  },
                );
    }

    Widget RankingsTab() {
      return event.divisions?[0].rankings?.data?.isEmpty == true
          ? const Center(child: Text("No rankings found"))
          : RefreshIndicator(
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaleFactor: 1.0)
                    .removePadding(removeTop: true),
                child: ListView(children: [
                  divisions.length == 1
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              const Text("Division",
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownValue = value!;
                                      selectedDivison = divisions.indexOf(dropdownValue);
                                    });
                                  },
                                  items: divisions.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          )),
                  if (event.divisions?[selectedDivison].rankings?.data?.isEmpty ?? true)
                    const Center(
                        heightFactor: 3,
                        child: Text(
                          "No rankings found\nNote: Finals divisions will not have rankings",
                          textAlign: TextAlign.center,
                        )),
                  if (event.divisions?[selectedDivison].rankings?.data?.isNotEmpty ?? false)
                    for (var i =
                            (((event.divisions?[selectedDivison].rankings?.data?.length ?? 1) - 1));
                        i >= 0;
                        i--)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => TeamPage(
                                  title: (event.divisions?[selectedDivison].rankings?.data?[i].team
                                          ?.name)
                                      .toString(),
                                  event_old: event,
                                  match_id: event.id.toString(),
                                  team_id: (event
                                          .divisions?[selectedDivison].rankings?.data?[i].team?.id)
                                      .toString()),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).cardColor,
                          ),
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          margin: const EdgeInsets.all(4),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                          alignment: PlaceholderAlignment.middle,
                                          child: Text(
                                            "${event.divisions?[selectedDivison].rankings?.data?[i].rank}. ",
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          )),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          (event.divisions?[selectedDivison].rankings?.data?[i].team
                                                  ?.name)
                                              .toString(),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "WP: ${(event.divisions?[selectedDivison].rankings?.data?[i].wp).toString()} AP: ${(event.divisions?[selectedDivison].rankings?.data?[i].ap).toString()} SP: ${(event.divisions?[selectedDivison].rankings?.data?[i].sp).toString()}      ${event.divisions?[selectedDivison].rankings?.data?[i].wins}-${event.divisions?[selectedDivison].rankings?.data?[i].losses}-${event.divisions?[selectedDivison].rankings?.data?[i].ties}",
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.tertiary,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ]),
              ),
              onRefresh: () async {
                await getEventDetailsThrottled();
              },
            );
    }

    Widget SkillsTab() {
      return _skills.isEmpty
          ? const Center(child: Text("No skills found"))
          : RefreshIndicator(
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaleFactor: 1.0)
                    .removePadding(removeTop: true),
                child: ListView(children: [
                  for (var i = 0; i < _skills.length; i++)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => TeamPage(
                                title: (_skills[i].teamNumber).toString(),
                                event_old: event,
                                match_id: event.id.toString(),
                                team_id: (_skills[i].teamId).toString()),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor,
                        ),
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        margin: const EdgeInsets.all(4),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text(
                                          "${i + 1}. ",
                                          style: TextStyle(
                                              color: Theme.of(context).colorScheme.secondary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Text(
                                        (_skills[i].teamNumber).toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Text(
                                        "Total: ${_skills[i].driverScore + _skills[i].programmingScore}   Driver: ${_skills[i].driverScore}   Prog: ${_skills[i].programmingScore}",
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.tertiary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ]),
              ),
              onRefresh: () async {
                await getEventDetailsThrottled();
              },
            );
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text(widget.title,
                      style: const TextStyle(
                        overflow: TextOverflow.fade,
                      )),
                  actions: [
                    IconButton(
                      icon: ref
                              .read(favoriteCompsProvider.notifier)
                              .state
                              .contains(event.id.toString())
                          ? const Icon(Icons.star)
                          : const Icon(Icons.star_border_outlined),
                      onPressed: () {
                        List<String> oldState = ref.read(favoriteCompsProvider.notifier).state;
                        if (oldState.contains(event.id.toString())) {
                          oldState.remove(event.id.toString());
                        } else {
                          oldState.add(event.id.toString());
                        }
                        ref
                            .read(favoriteCompsProvider.notifier)
                            .update((state) => oldState.toList());

                        SharedPreferences.getInstance().then(
                            (prefs) => prefs.setStringList('favoriteComps', oldState.toList()));
                      },
                    ),
                  ],
                  pinned: true,
                  forceElevated: innerBoxIsScrolled,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      (event.divisions?[0].data?.data).toString() == "null"
                          ? const Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  RefreshIndicator(
                                    child: Container(
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
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            if (Platform.isAndroid) {
                                                              launchUrl(
                                                                  Uri.parse(
                                                                      "https://maps.google.com/?q=${event.location?.venue.toString()} ${event.location?.address1.toString()}, ${event.location?.city.toString()} ${event.location?.country.toString()}"),
                                                                  mode: LaunchMode
                                                                      .externalApplication);
                                                            } else if (Platform.isIOS) {
                                                              launchUrl(
                                                                  Uri.parse(
                                                                      "https://maps.apple.com/?q=${event.location?.venue.toString()} ${event.location?.address1.toString()}, ${event.location?.city.toString()} ${event.location?.country.toString()}"),
                                                                  mode: LaunchMode
                                                                      .externalApplication);
                                                            }
                                                            log("Redirect to navigation app");
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(10),
                                                              color:
                                                                  Theme.of(context).scaffoldBackgroundColor,
                                                            ),
                                                            padding: const EdgeInsets.all(10),
                                                            margin: const EdgeInsets.symmetric(
                                                                horizontal: 10),
                                                            child: const Icon(
                                                                Icons.navigation_rounded,
                                                                size: 30),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            launchUrl(
                                                                Uri.parse(
                                                                    "https://www.robotevents.com/robot-competitions/vex-robotics-competition/${event.sku}.html"),
                                                                mode:
                                                                    LaunchMode.externalApplication);
                                                            log("Redirect to web browser with comp link");
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(10),
                                                              color:
                                                                  Theme.of(context).scaffoldBackgroundColor,
                                                            ),
                                                            padding: const EdgeInsets.all(10),
                                                            child: const Icon(Icons.link, size: 30),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ]))
                                        ])),
                                    onRefresh: () async {
                                      await getEventDetailsThrottled();
                                    },
                                  ),
                                  TabBar(
                                    indicatorColor: Theme.of(context).colorScheme.secondary,
                                    labelPadding: const EdgeInsets.all(0),
                                    tabs: const [
                                      Tab(icon: Icon(Icons.schedule), text: "Matches"),
                                      Tab(icon: Icon(Icons.people), text: "Teams"),
                                      Tab(icon: Icon(Icons.bar_chart), text: "Rankings"),
                                      Tab(
                                          icon: Icon(Icons.precision_manufacturing),
                                          text: "Skills"),
                                    ],
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                )
              ];
            },
            body: TabBarView(
              children: [MatchesTab(), TeamsTab(), RankingsTab(), SkillsTab()],
            ),
          ),
        ),
      ),
    );
  }
}
