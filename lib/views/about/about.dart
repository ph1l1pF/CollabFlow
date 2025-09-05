import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collabflow/l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String developerName = 'Philip Frerk';
  static const String developerEmail = 'philip.frerk@gmail.com';
  static const String appStoreLink = 'https://testflight.apple.com/join/QQc1cXU6';

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: developerEmail,
      query: 'subject=Feedback%20zu%20CollabFlow',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _shareApp() async {
    await Share.share(appStoreLink);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.appTitle ?? 'CollabFlow'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)?.developer ?? 'Developer:'),
            Text(
              developerName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)?.feedbackTo ?? 'Feedback to:'),
            Text(
              developerEmail,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _sendEmail,
                  icon: const Icon(Icons.mail),
                  label: Text(AppLocalizations.of(context)?.sendEmail ?? 'Send Email'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _shareApp,
                  icon: const Icon(Icons.share),
                  label: Text(AppLocalizations.of(context)?.shareApp ?? 'Share App'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


