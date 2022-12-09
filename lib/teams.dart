import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vrc_ranks_app/teamEvents.dart';
import 'Request.dart' as Request;
import 'Schema/TeamsSearch.dart' as TeamsSearch;

class TeamsPage extends StatefulWidget {
  const TeamsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  void searchTeams(String query, String grade) {
    Request.getTeams(query, grade).then((value) {
      if (this.mounted) {
        setState(() {
          _teams = value;
          teams = value;
        });
      }
    });
  }

  List<TeamsSearch.Item> _teams = <TeamsSearch.Item>[];

  List<TeamsSearch.Item> teams = <TeamsSearch.Item>[];

  String dropdownValue = "All";
  String searchValue = "";

  void filterSearchResults() {
    setState(() {
      searchTeams(searchValue, dropdownValue);
    });
  }

  @override
  void initState() {
    super.initState();
    filterSearchResults();
  }

  @override
  Widget build(BuildContext context) {
    getTeams() async => {filterSearchResults()};

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: RefreshIndicator(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Flex(direction: Axis.horizontal, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  items: const [
                    DropdownMenuItem<String>(
                      value: "All",
                      child: Text("All"),
                    ),
                    DropdownMenuItem<String>(
                      value: "High School",
                      child: Text("HS"),
                    ),
                    DropdownMenuItem<String>(
                      value: "Middle School",
                      child: Text("MS"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value!;
                      filterSearchResults();
                    });
                  },
                ),
              ),
              Expanded(
                flex: 10,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchValue = value;
                    });
                    filterSearchResults();
                  },
                  decoration: InputDecoration(
                      labelText: "Search",
                      labelStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
            ]),
            if (teams.isEmpty)
              const Center(
                  heightFactor: 35, child: Text("There are no teams matching your search")),
            for (var team in teams)
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            TeamEventsPage(title: (team.number).toString(), team_id: team.id!)),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).cardColor,
                  ),
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
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
                      if (team.organization != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              (team.organization).toString(),
                              style: TextStyle(
                                  fontSize: 16, color: Theme.of(context).colorScheme.tertiary),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        onRefresh: () async {
          await getTeams();
        },
      ),
    );
  }
}
