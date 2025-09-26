import 'package:ugcworks/models/collaboration.dart';
import 'package:ugcworks/repositories/collaborations-repository.dart';
import 'package:ugcworks/repositories/notifications-repository.dart';
import 'package:ugcworks/repositories/shared-prefs-repository.dart';
import 'package:ugcworks/services/auth-service.dart';
import 'package:ugcworks/services/collaboration-export-service.dart';
import 'package:ugcworks/services/secure-storage-service.dart';
import 'package:ugcworks/services/collaborations-api-service.dart';
import 'package:ugcworks/views/collaborations-list/collaborations-list.dart';
import 'package:ugcworks/views/collaborations-list/collaboration-list-view-model.dart';
import 'package:ugcworks/views/earnings-overview/earnings-overview-view-model.dart';
import 'package:ugcworks/views/earnings-overview/earnings-overview.dart';
import 'package:ugcworks/views/dashboard/dashboard.dart';
import 'package:ugcworks/views/about/settings.dart';
import 'package:ugcworks/views/onboarding/onboarding.dart';
import 'package:ugcworks/views/create-collaboration/create-collaboration.dart';
import 'package:ugcworks/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:ugcworks/l10n/app_localizations.dart';
import 'package:ugcworks/utils/theme_utils.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Hive.deleteFromDisk();
  
  await Hive.initFlutter("ugcworks");
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
        Provider(
          create: (_) => AuthService(),
        ),
        Provider(
          create: (_) => SecureStorageService(),
        ),
        Provider(
          create: (context) => CollaborationsApiService(
            secureStorageService: Provider.of<SecureStorageService>(context, listen: false),
            collaborationsRepository: Provider.of<CollaborationsRepository>(context, listen: false),
            sharedPrefsRepository: Provider.of<SharedPrefsRepository>(context, listen: false),
          ),
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  bool _onboardingDone = false;

  final List<Widget> _pages = [
    const DashboardPage(),
    const CollaborationListPage(),
    const EarningsOverviewPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _onboardingDone = widget.onboardingDone;
    
    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    final apiService = Provider.of<CollaborationsApiService>(context, listen: false);
    
    switch (state) {
      case AppLifecycleState.resumed:
        // App is in the foreground and active
        apiService.syncDirtyCollaborations();
        break;
      case AppLifecycleState.paused:
        // App is in the background
        apiService.syncDirtyCollaborations();
        break;
      case AppLifecycleState.inactive:
        // App is in an inactive state (e.g., phone call, notification panel)
        break;
      case AppLifecycleState.detached:
        // App is detached
        break;
      case AppLifecycleState.hidden:
        // App is hidden
        break;
    }
  }

  @override
  void dispose() {
    // Remove lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
  }


  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryPink),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
    );

    final darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPink,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
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
        home: Builder(
          builder: (context) => Container(
            decoration: ThemeUtils.getBackgroundDecoration(context),
            child: OnboardingScreen(
              onComplete: () {
                setState(() {
                  _onboardingDone = true;
                });
              },
            ),
          ),
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
      home: Builder(
        builder: (context) => Container(
          decoration: ThemeUtils.getBackgroundDecoration(context),
          child: _MainAppContent(
            selectedIndex: _selectedIndex,
            onIndexChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            pages: _pages,
          ),
        ),
      ),
    );
  }
}

class _MainAppContent extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<Widget> pages;

  const _MainAppContent({
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.pages,
  });

  Widget _buildNavItem(IconData icon, int index, bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: () => onIndexChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Icon(
          icon,
          size: 30,
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? 
                 Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Left group: Dashboard and Collaborations
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Row(
                children: [
                  _buildNavItem(Icons.analytics, 0, selectedIndex == 0, context),
                  const SizedBox(width: 20),
                  _buildNavItem(Icons.list, 1, selectedIndex == 1, context),
                ],
              ),
            ),
            // Right group: Earnings and Settings
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Row(
                children: [
                  _buildNavItem(Icons.euro, 2, selectedIndex == 2, context),
                  const SizedBox(width: 20),
                  _buildNavItem(Icons.settings, 3, selectedIndex == 3, context),
                ],
              ),
            ),
            // Plus button in the center between menu items
            Positioned(
              left: 0,
              right: 0,
              top: -19,
              bottom: 8,
              child: Center(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CollaborationWizard(),
                          ),
                        );
                      },
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
