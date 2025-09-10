import 'package:collabflow/views/apple-login/apple-login.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collabflow/l10n/app_localizations.dart';
import 'package:collabflow/repositories/shared-prefs-repository.dart';
import 'package:collabflow/services/secure-storage-service.dart';
import 'package:collabflow/constants/api_config.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool _isRefreshTokenExpired = false;

  static const String developerName = 'Philip Frerk';
  static const String developerEmail = 'philip.frerk@gmail.com';
  static const String appStoreLink = 'https://testflight.apple.com/join/QQc1cXU6';

  @override
  void initState() {
    super.initState();
    _checkRefreshTokenStatus();
  }

  Future<void> _checkRefreshTokenStatus() async {
    final sharedPrefsRepository = Provider.of<SharedPrefsRepository>(context, listen: false);
    final isExpired = await sharedPrefsRepository.isRefreshTokenExpired();
    if (mounted) {
      setState(() {
        _isRefreshTokenExpired = isExpired;
      });
    }
  }

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
            // Refresh token expired warning
            if (_isRefreshTokenExpired) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)?.refreshTokenExpiredTitle ?? 'Login Required',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)?.refreshTokenExpiredMessage ?? 
                      'Your session has expired. Please sign in again to sync your data.',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
            
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
            const SizedBox(height: 16),
            AppleLoginButton(
              onSuccess: () {
                _clearRefreshTokenExpiredFlag();
              },
            ),
            
            // Debug info (only in debug mode)
            if (const bool.fromEnvironment('dart.vm.product') == false) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Debug Info',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Environment: ${ApiConfig.isDevelopment ? 'Development' : 'Production'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('API URL: ${ApiConfig.baseUrl}'),
                    const SizedBox(height: 4),
                    Text('Dev URL: ${ApiConfig.devUrl}'),
                    const SizedBox(height: 4),
                    Text('Prod URL: ${ApiConfig.prodUrl}'),
                  ],
                ),
              ),
            ],
            
            // Debug button (only in debug mode)
            if (const bool.fromEnvironment('dart.vm.product') == false) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Debug Tools',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _clearSecureStorage,
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                label: const Text('Clear Secure Storage'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _clearRefreshTokenExpiredFlag() async {
    final sharedPrefsRepository = Provider.of<SharedPrefsRepository>(context, listen: false);
    await sharedPrefsRepository.setRefreshTokenExpired(false);
    if (mounted) {
      setState(() {
        _isRefreshTokenExpired = false;
      });
    }
  }

  Future<void> _clearSecureStorage() async {
    final secureStorageService = Provider.of<SecureStorageService>(context, listen: false);
    await secureStorageService.clearAllSecureData();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Secure storage cleared successfully"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}


