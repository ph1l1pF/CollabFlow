import 'package:collabflow/models/collaboration.dart';
import 'package:collabflow/repositories/collaborations-repository.dart';
import 'package:collabflow/repositories/notifications-repository.dart';
import 'package:collabflow/repositories/shared-prefs-repository.dart';
import 'package:collabflow/services/collaboration-export-service.dart';
import 'package:collabflow/views/collaborations-list/collaborations-list.dart';
import 'package:collabflow/views/collaborations-list/collaboration-list-view-model.dart';
import 'package:collabflow/views/earnings-overview/earnings-overview-view-model.dart';
import 'package:collabflow/views/earnings-overview/earnings-overview.dart';
import 'package:collabflow/views/about/about.dart';
import 'package:collabflow/views/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:collabflow/l10n/app_localizations.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Hive.deleteFromDisk();
  
  await Hive.initFlutter("collabflow");
  Hive.registerAdapter(CollaborationAdapter());
  Hive.registerAdapter(PartnerAdapter());
  Hive.registerAdapter(ScriptAdapter());
  Hive.registerAdapter(FeeAdapter());
  Hive.registerAdapter(RequirementsAdapter());
  Hive.registerAdapter(CollabStateAdapter());
  Hive.registerAdapter(DeadlineAdapter());

  await Hive.openBox<Collaboration>('collaborations');

  tz.initializeTimeZones();

  final notificationsRepo = NotificationsRepository();
  // Prüfe, ob Onboarding abgeschlossen ist
  final sharedPrefsRepository = SharedPrefsRepository();
  final onboardingDone = await sharedPrefsRepository.getOnboardingDone();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CollaborationsRepository(notificationsRepo: notificationsRepo),
        ),
        ChangeNotifierProvider(
              create: (context) => CollaborationsListViewModel(
                collaborationsRepository: Provider.of<CollaborationsRepository>(context, listen: false),
              ),
            ),
        ChangeNotifierProvider(
              create: (context) => EarningsOverviewViewModel(
                collaborationsRepository: Provider.of<CollaborationsRepository>(context, listen: false),
              ),
            ),
        Provider(
          create: (_) => sharedPrefsRepository,
        ),
        Provider(
          create: (_) => notificationsRepo,
        ),
        Provider(
          create: (_) => CollaborationExportService(),
        ),
      ],
      child: MyApp(onboardingDone: onboardingDone),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool onboardingDone;
  const MyApp({super.key, required this.onboardingDone});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  bool _onboardingDone = false;

  final List<Widget> _pages = [
    const CollaborationListPage(),
    const EarningsOverviewPage(),
    const AboutPage(),
  ];

  @override
  void initState() {
    super.initState();
    _onboardingDone = widget.onboardingDone;
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      useMaterial3: true,
    );

    final darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightBlue,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

    if (!_onboardingDone) {
      return MaterialApp(
        title: '',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('de', ''),
        ],
        home: OnboardingScreen(
          onComplete: () {
            setState(() {
              _onboardingDone = true;
            });
          },
        ),
      );
    }

    return MaterialApp(
      title: '',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('de', ''),
      ],
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              label: AppLocalizations.of(context)?.collaborations ?? 'Collaborations',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.euro),
              label: AppLocalizations.of(context)?.earnings ?? 'Earnings',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.info_outline),
              label: AppLocalizations.of(context)?.about ?? 'About',
            ),
          ],
        ),
      ),
    );
  }
}
