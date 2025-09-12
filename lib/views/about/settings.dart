import 'package:collabflow/services/collaborations-api-service.dart';
import 'package:collabflow/views/apple-login/apple-login.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collabflow/l10n/app_localizations.dart';
import 'package:collabflow/repositories/shared-prefs-repository.dart';
import 'package:collabflow/services/secure-storage-service.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isRefreshTokenExpired = false;
  bool _isAuthenticated = false;

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
    final secureStorageService = Provider.of<SecureStorageService>(context, listen: false);
    final isAuthenticated = await secureStorageService.isAuthenticated();
    if (mounted) {
      setState(() {
        _isRefreshTokenExpired = isExpired;
        _isAuthenticated = isAuthenticated;
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
        title: Text(AppLocalizations.of(context)?.settings ?? 'Settings'),
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
            
            if (_isAuthenticated) ...[
              const SizedBox(height: 24),
              
              ElevatedButton.icon(
                onPressed: _clearSecureStorage,
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                label: Text(AppLocalizations.of(context)?.deleteAccount ?? 'Delete Account'),
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
    final apiService = Provider.of<CollaborationsApiService>(context, listen: false);
    await apiService.deleteAll();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.accountDeleted ?? 'Account deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}


