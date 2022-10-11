import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrc_ranks_app/events.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vrc_ranks_app/favorites.dart';
import 'package:vrc_ranks_app/themeData.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VEX Ranks App',
      theme: Styles.themeData(false, context),
      darkTheme: Styles.themeData(true, context),
      themeMode: ThemeMode.system,
      home: const MainPage(),
    );
  }
}

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const EventsPage(title: "VRC Ranks App"),
    const Icon(
      Icons.people,
      size: 150,
    ),
    const FavoritesPage()
  ];

  @override
  void initState() {
    super.initState();

    final favoriteCompsState = ref.read(favoriteCompsProvider.notifier).state;
    if (favoriteCompsState.isEmpty) {
      SharedPreferences.getInstance().then((prefs) {
        List<String> favoriteComps = prefs.getStringList('favoriteComps') ?? [];
        ref.read(favoriteCompsProvider.notifier).update((state) => favoriteComps);
      });
    }

    final favoriteTeamsState = ref.read(favoriteTeamsProvider.notifier).state;
    if (favoriteTeamsState.isEmpty) {
      SharedPreferences.getInstance().then((prefs) {
        List<String> favoriteTeams = prefs.getStringList('favoriteTeams') ?? [];
        ref.read(favoriteTeamsProvider.notifier).update((state) => favoriteTeams);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('VRC Ranks App'),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
