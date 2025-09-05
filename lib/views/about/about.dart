import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String developerName = 'Philip Frerk';
  static const String developerEmail = 'philip.frerk@gmail.com';
  static const String appStoreLink = 'https://example.com/app';

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
        title: const Text('CollabFlow'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Entwickler:'),
            Text(
              developerName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text('Feedback an:'),
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
                  label: const Text('E-Mail senden'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _shareApp,
                  icon: const Icon(Icons.share),
                  label: const Text('App teilen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


