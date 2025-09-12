import 'package:collabflow/repositories/shared-prefs-repository.dart';
import 'package:collabflow/views/collaborations-list/collaborations-list.dart';
import 'package:collabflow/views/apple-login/apple-login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:collabflow/l10n/app_localizations.dart';
import 'package:collabflow/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  
  const OnboardingScreen({super.key, this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  void _nextPage() {
    if (_controller.page! < 5) {
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
              // 👉 Erste Seite
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
                      AppLocalizations.of(context)?.welcomeMessage ?? "Tired of managing your collaborations in Excel, note apps and calendars?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
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
                  ],
                ),
              ),

              // 👉 Zweite Seite
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.keepTrack ?? "Keep track of all your collaborations in one place 📊",
                      style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onSurface),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(AppLocalizations.of(context)?.next ?? "Next"),
                    ),
                  ],
                ),
              ),

              // 👉 Neue drittletzte Seite (Deadlines)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.notifications ?? "Get automatically notified when deadlines expire ⏰",
                      style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onSurface),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(AppLocalizations.of(context)?.next ?? "Next"),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.startNow ?? "Start now and save yourself from chaos and Excel lists 🚀",
                      style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onSurface),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(AppLocalizations.of(context)?.next ?? "Next"),
                    ),
                  ],
                ),
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
                    ),
                    const SizedBox(height: 16),
                    // Skip option
                    TextButton(
                      onPressed: _nextPage,
                      child: Text(
                        AppLocalizations.of(context)?.skip ?? "Skip for now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 👉 Final page
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.startNow ?? "Start now and save yourself from chaos and Excel lists 🚀",
                      style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onSurface),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(AppLocalizations.of(context)?.letsGo ?? "Let's go"),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 👉 Indicator + Skip
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 5, 
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.primaryPink,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    onFinish(context);
                  },
                  child: Text(AppLocalizations.of(context)?.skip ?? "Skip"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
