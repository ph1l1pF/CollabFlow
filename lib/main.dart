import 'package:collabflow/models/collaboration.dart';
import 'package:collabflow/repositories/collaborations-repository.dart';
import 'package:collabflow/repositories/shared-prefs-repository.dart';
import 'package:collabflow/views/collaborations-list/collaborations-list.dart';
import 'package:collabflow/views/collaborations-list/view-models/collaboration-list.dart';
import 'package:collabflow/views/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

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

  await Hive.openBox<Collaboration>('collaborations');

  // Prüfe, ob Onboarding abgeschlossen ist
  final sharedPrefsRepository = SharedPrefsRepository();
  final onboardingDone = await sharedPrefsRepository.getOnboardingDone();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CollaborationsRepository(),
        ),
        Provider(
          create: (_) => sharedPrefsRepository,
        ),
      ],
      child: MyApp(onboardingDone: onboardingDone),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool onboardingDone;
  const MyApp({super.key, required this.onboardingDone});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: onboardingDone
          ? CollaborationListPage(
              viewModel: CollaborationsListViewModel(
                collaborationsRepository: Provider.of<CollaborationsRepository>(context),
              ),
            )
          : OnboardingScreen(),
    );
  }
}
