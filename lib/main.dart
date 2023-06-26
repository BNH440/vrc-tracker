import 'dart:async';
import 'dart:isolate';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:vrc_ranks_app/Hive/Event.dart';
import 'package:vrc_ranks_app/Hive/Team.dart';
import 'package:vrc_ranks_app/Schema/Team.dart' hide Team;
import 'package:vrc_ranks_app/events.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vrc_ranks_app/favorites.dart';
import 'package:vrc_ranks_app/teams.dart';
import 'package:vrc_ranks_app/themeData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future main() async {
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
      fatal: true,
    );
  }).sendPort);

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    await FirebaseAnalytics.instance.logEvent(name: 'app_open');

    await dotenv.load(fileName: ".env");

    // Init Hive
    await Hive.initFlutter();
    Hive.registerAdapter<Coordinates>(CoordinatesAdapter());
    Hive.registerAdapter<Location>(LocationAdapter());
    Hive.registerAdapter<Team>(TeamAdapter());
    Hive.registerAdapter<Event>(EventAdapter());
    await Hive.openBox<Team>('teams');
    await Hive.openBox<Event>('eventNames');

    // if (kDebugMode) await Upgrader.clearSavedSettings();

    runApp(const ProviderScope(child: MyApp()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
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
      home: UpgradeAlert(
        child: const MainPage(),
      ),
      debugShowCheckedModeBanner: false,
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
    const EventsPage(title: "VRC Tracker"),
    const TeamsPage(title: "VRC Tracker"),
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

    const titleList = ["Events", "Teams", "Favorites"];

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text(titleList[_selectedIndex]),
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
      ),
    );
  }
}
