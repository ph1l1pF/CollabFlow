import 'package:ugcworks/repositories/shared-prefs-repository.dart';
import 'package:ugcworks/views/collaborations-list/collaborations-list.dart';
import 'package:ugcworks/views/apple-login/apple-login.dart';
import 'package:ugcworks/views/create-collaboration/create-collaboration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ugcworks/l10n/app_localizations.dart';
import 'package:ugcworks/constants/app_colors.dart';
import 'package:ugcworks/services/analytics_service.dart';
import 'package:ugcworks/services/onboarding_service.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  
  const OnboardingScreen({super.key, this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  
  // Antworten für die Fragen (immer auf Englisch gespeichert für konsistente Firestore-Daten)
  String? _collaborationsLast3Months;
  String? _timePerWeek;
  List<String> _stressfulAspects = [];
  List<String> _organizationMethods = [];

  /// Map localized option to English value for consistent storage
  String _mapToEnglish(String localizedValue) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return localizedValue;
    
    // Question 1: collaborationsLast3Months
    if (localizedValue == loc.onboardingQuestion1Option1) return '1-3';
    if (localizedValue == loc.onboardingQuestion1Option2) return '4-10';
    if (localizedValue == loc.onboardingQuestion1Option3) return 'more than 10';
    
    // Question 2: timePerWeek
    if (localizedValue == loc.onboardingQuestion2Option1) return '< 30 minutes';
    if (localizedValue == loc.onboardingQuestion2Option2) return '30–60 minutes';
    if (localizedValue == loc.onboardingQuestion2Option3) return '1–2 hours';
    if (localizedValue == loc.onboardingQuestion2Option4) return '2+ hours';
    
    // Question 3: stressfulAspects
    if (localizedValue == loc.onboardingQuestion3Option1) return 'Keeping track of deadlines';
    if (localizedValue == loc.onboardingQuestion3Option2) return 'Overview of ongoing projects';
    if (localizedValue == loc.onboardingQuestion3Option3) return 'Communications with brands';
    if (localizedValue == loc.onboardingQuestion3Option4) return 'Tracking invoices / earnings';
    if (localizedValue == loc.onboardingQuestion3Option5) return 'Finding files & briefings';
    if (localizedValue == loc.onboardingQuestion3Option6) return 'None of the above';
    
    // Question 4: organizationMethods
    if (localizedValue == loc.onboardingQuestion4Option1) return 'Excel / Google Sheets';
    if (localizedValue == loc.onboardingQuestion4Option2) return 'Notes app';
    if (localizedValue == loc.onboardingQuestion4Option3) return 'Calendar';
    if (localizedValue == loc.onboardingQuestion4Option4) return 'Email';
    if (localizedValue == loc.onboardingQuestion4Option5) return 'Other tools';
    if (localizedValue == loc.onboardingQuestion4Option6) return 'Not organized';
    
    // Fallback: assume it's already in English
    return localizedValue;
  }


  void _nextPage() {
    // Total pages: 1 welcome + 4 questions + 1 Apple Sign-In + 1 Create First Collaboration = 7 pages (0-6)
    if (_controller.page! < 6) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      onFinish(context);
    }
  }

  Future<void> onFinish(BuildContext context) async {
    final repo = Provider.of<SharedPrefsRepository>(context, listen: false);
    await repo.setOnboardingDone();
    
    // Analytics: finished
    Provider.of<AnalyticsService>(context, listen: false).logOnboardingFinished();
    
    // Save onboarding responses to Firestore
    try {
      final onboardingService = Provider.of<OnboardingService>(context, listen: false);
      await onboardingService.saveOnboardingData({
        if (_collaborationsLast3Months != null) 'collaborationsLast3Months': _collaborationsLast3Months,
        if (_timePerWeek != null) 'timePerWeek': _timePerWeek,
        if (_stressfulAspects.isNotEmpty) 'stressfulAspects': _stressfulAspects,
        if (_organizationMethods.isNotEmpty) 'organizationMethods': _organizationMethods,
        'completed': true,
      });
    } catch (e) {
      debugPrint('Failed to save onboarding data: $e');
      // Continue even if Firestore save fails
    }
    
    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CollaborationListPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(), // nur über Button weiter
            children: [
              // 👉 Erste Seite - Welcome
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.handshake,
                      size: 100,
                      color: AppColors.primaryPink,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context)?.welcomeCreator ?? "Welcome, Creator! 👋",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)?.welcomeMessage ?? "UGCWorks helps you keeping track of your collaborations and managing them in a smart way.\nLet's start with a few questions first",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.next ?? "Next",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 80), // Extra padding to avoid overlap with progress indicator
                  ],
                ),
              ),

              // 👉 Frage 1: Wie viele collaborations hattest du in den letzten 3 monaten?
              _buildQuestionPage(
                question: AppLocalizations.of(context)?.onboardingQuestion1 ?? 'Wie viele Collaborations hattest du in den letzten 3 Monaten?',
                options: [
                  AppLocalizations.of(context)?.onboardingQuestion1Option1 ?? '1-3',
                  AppLocalizations.of(context)?.onboardingQuestion1Option2 ?? '4-10',
                  AppLocalizations.of(context)?.onboardingQuestion1Option3 ?? 'mehr als 10',
                ],
                selectedValue: _collaborationsLast3Months,
                onSelected: (value) {
                  setState(() {
                    _collaborationsLast3Months = _mapToEnglish(value);
                  });
                },
              ),

              // 👉 Frage 2: Wie viel Zeit pro Woche verbringst du mit Organisation statt Content?
              _buildQuestionPage(
                question: AppLocalizations.of(context)?.onboardingQuestion2 ?? 'Wie viel Zeit pro Woche verbringst du mit Organisation statt Content?',
                options: [
                  AppLocalizations.of(context)?.onboardingQuestion2Option1 ?? '< 30 Minuten',
                  AppLocalizations.of(context)?.onboardingQuestion2Option2 ?? '30–60 Minuten',
                  AppLocalizations.of(context)?.onboardingQuestion2Option3 ?? '1–2 Stunden',
                  AppLocalizations.of(context)?.onboardingQuestion2Option4 ?? '2+ Stunden',
                ],
                selectedValue: _timePerWeek,
                onSelected: (value) {
                  setState(() {
                    _timePerWeek = _mapToEnglish(value);
                  });
                },
              ),

              // 👉 Frage 3: Was ist aktuell am stressigsten bei collaborations?
              _buildMultiSelectQuestionPage(
                question: AppLocalizations.of(context)?.onboardingQuestion3 ?? 'Was ist aktuell am stressigsten bei Collaborations?',
                options: [
                  AppLocalizations.of(context)?.onboardingQuestion3Option1 ?? 'Deadlines im Blick behalten',
                  AppLocalizations.of(context)?.onboardingQuestion3Option2 ?? 'Überblick über laufende Projekte',
                  AppLocalizations.of(context)?.onboardingQuestion3Option3 ?? 'Absprachen mit Brands',
                  AppLocalizations.of(context)?.onboardingQuestion3Option4 ?? 'Rechnungen / Einnahmen tracken',
                  AppLocalizations.of(context)?.onboardingQuestion3Option5 ?? 'Dateien & Briefings finden',
                  AppLocalizations.of(context)?.onboardingQuestion3Option6 ?? 'Nichts davon',
                ],
                selectedValues: _stressfulAspects,
                onSelectionChanged: (values) {
                  setState(() {
                    _stressfulAspects = values.map((v) => _mapToEnglish(v)).toList();
                  });
                },
              ),

              // 👉 Frage 4: Wie organisierst du deine Deals?
              _buildMultiSelectQuestionPage(
                question: AppLocalizations.of(context)?.onboardingQuestion4 ?? 'Wie organisierst du deine Deals?',
                options: [
                  AppLocalizations.of(context)?.onboardingQuestion4Option1 ?? 'Excel / Google Sheets',
                  AppLocalizations.of(context)?.onboardingQuestion4Option2 ?? 'Notizen-App',
                  AppLocalizations.of(context)?.onboardingQuestion4Option3 ?? 'Kalender',
                  AppLocalizations.of(context)?.onboardingQuestion4Option4 ?? 'E-Mail',
                  AppLocalizations.of(context)?.onboardingQuestion4Option5 ?? 'Andere Tools',
                  AppLocalizations.of(context)?.onboardingQuestion4Option6 ?? 'Gar nicht organisiert',
                ],
                selectedValues: _organizationMethods,
                onSelectionChanged: (values) {
                  setState(() {
                    _organizationMethods = values.map((v) => _mapToEnglish(v)).toList();
                  });
                },
              ),

              // 👉 Apple Sign-In Seite
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_sync,
                      size: 80,
                      color: AppColors.primaryPink,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context)?.cloudSyncTitle ?? "Sync your data in the cloud ☁️",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)?.cloudSyncMessage ?? "Sign in with Apple to securely store your collaborations in the cloud. Your data will be safe and accessible across all your devices.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: 40),
                    // Apple Sign-In Button
                    AppleLoginButton(
                      onSuccess: _nextPage,
                      forceLoginState: true, // Force login state in onboarding
                    ),
                    const SizedBox(height: 16),
                    // Skip option (only on Apple Login page)
                    TextButton(
                      onPressed: () {
                        _nextPage();
                      },
                      child: Text(
                        AppLocalizations.of(context)?.skip ?? "Skip for now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80), // Extra padding to avoid overlap with progress indicator
                  ],
                ),
              ),

              // 👉 Create First Collaboration page
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      size: 100,
                      color: AppColors.primaryPink,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context)?.createFirstCollaboration ?? "Create Your First Collaboration",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)?.createFirstCollaborationMessage ?? "Let's get you started! Create your first collaboration to see how UGCWorks works.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CollaborationWizard(),
                          ),
                        ).then((_) {
                          // After creating collaboration, finish onboarding
                          onFinish(context);
                        });
                      },
                      style: AppColors.primaryButtonStyle,
                      child: Text(
                        AppLocalizations.of(context)?.createFirstCollaborationButton ?? "Create First Collaboration",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 80), // Extra padding to avoid overlap with progress indicator
                  ],
                ),
              ),
            ],
          ),

          // 👉 Indicator
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 7, // 1 welcome + 4 questions + 1 Apple Sign-In + 1 Create First Collaboration
                effect: const ExpandingDotsEffect(
                  activeDotColor: AppColors.primaryPink,
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build single-select question page
  Widget _buildQuestionPage({
    required String question,
    required List<String> options,
    String? selectedValue,
    required Function(String) onSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          ...options.map((option) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onSelected(option);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _nextPage();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedValue != null && _mapToEnglish(option) == selectedValue
                      ? AppColors.primaryPink
                      : Theme.of(context).colorScheme.surface,
                  foregroundColor: selectedValue != null && _mapToEnglish(option) == selectedValue
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: selectedValue != null && _mapToEnglish(option) == selectedValue
                          ? AppColors.primaryPink
                          : Colors.grey.shade300,
                      width: selectedValue != null && _mapToEnglish(option) == selectedValue ? 2 : 1,
                    ),
                  ),
                ),
                child: Text(
                  option,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          )),
          const SizedBox(height: 80), // Extra padding to avoid overlap with progress indicator
        ],
      ),
    );
  }

  // Helper method to build multi-select question page
  Widget _buildMultiSelectQuestionPage({
    required String question,
    required List<String> options,
    required List<String> selectedValues,
    required Function(List<String>) onSelectionChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Fixed header at top
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 16),
            child: Text(
              question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context)?.multipleSelectionPossible ?? '(Mehrfachauswahl möglich)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          // Scrollable options list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: options.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final englishValue = _mapToEnglish(option);
                      final newSelection = List<String>.from(selectedValues);
                      if (newSelection.contains(englishValue)) {
                        newSelection.remove(englishValue);
                      } else {
                        newSelection.add(englishValue);
                      }
                      onSelectionChanged(newSelection);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedValues.contains(_mapToEnglish(option))
                          ? AppColors.primaryPink
                          : Theme.of(context).colorScheme.surface,
                      foregroundColor: selectedValues.contains(_mapToEnglish(option))
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selectedValues.contains(_mapToEnglish(option))
                              ? AppColors.primaryPink
                              : Colors.grey.shade300,
                          width: selectedValues.contains(_mapToEnglish(option)) ? 2 : 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Icon(
                          selectedValues.contains(_mapToEnglish(option))
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: selectedValues.contains(_mapToEnglish(option))
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Fixed button at bottom (disabled if no selection)
          Padding(
            padding: const EdgeInsets.only(bottom: 80), // Extra padding to avoid overlap with progress indicator
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedValues.isNotEmpty ? _nextPage : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedValues.isNotEmpty 
                      ? AppColors.primaryPink 
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                ),
                child: Text(
                  AppLocalizations.of(context)?.next ?? "Next",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
