import 'package:collabflow/services/collaborations-api-service.dart';
import 'package:collabflow/views/apple-login/apple-login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const String appStoreLink =
      'https://testflight.apple.com/join/QQc1cXU6';

  @override
  void initState() {
    super.initState();
    _checkRefreshTokenStatus();
  }

  Future<void> _checkRefreshTokenStatus() async {
    final sharedPrefsRepository = Provider.of<SharedPrefsRepository>(
      context,
      listen: false,
    );
    final isExpired = await sharedPrefsRepository.isRefreshTokenExpired();
    final secureStorageService = Provider.of<SecureStorageService>(
      context,
      listen: false,
    );
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
                          AppLocalizations.of(
                                context,
                              )?.refreshTokenExpiredTitle ??
                              'Login Required',
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
                      AppLocalizations.of(
                            context,
                          )?.refreshTokenExpiredMessage ??
                          'Your session has expired. Please sign in again to sync your data.',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
            
            // Warning for unauthenticated users
            if (!_isAuthenticated) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cloud_off, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)?.dataNotSecuredTitle ??
                              'Data Not Secured',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)?.dataNotSecuredMessage ??
                          'Your data is stored locally and not backed up in the cloud. Sign in with Apple to secure your data.',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
            
            AppleLoginButton(
              onSuccess: () {
                _clearRefreshTokenExpiredFlag();
              },
            ),
            const SizedBox(height: 24),
            if(_isAuthenticated) ...[
            ElevatedButton.icon(
                onPressed: _clearSecureStorage,
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                label: Text(
                  AppLocalizations.of(context)?.deleteAccount ??
                      'Delete Account',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  foregroundColor: Colors.red,
                ),
              ),
            ],
            // Support-Infos section (only when logged in)
            if (_isAuthenticated) ...[
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)?.supportInfo ?? 'Support-Infos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.userId ?? 'User ID:',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          FutureBuilder<String?>(
                            future: _getUserId(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                );
                              }
                              return Text(
                                snapshot.data ?? 'Loading...',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _copyUserId,
                      icon: const Icon(Icons.copy, size: 20),
                      tooltip: AppLocalizations.of(context)?.copyUserId ?? 'Copy User ID',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            // App-Infos section
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)?.appInfo ?? 'App-Infos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
                  label: Text(
                    AppLocalizations.of(context)?.sendEmail ?? 'Send Email',
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _shareApp,
                  icon: const Icon(Icons.share),
                  label: Text(
                    AppLocalizations.of(context)?.shareApp ?? 'Share App',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearRefreshTokenExpiredFlag() async {
    final sharedPrefsRepository = Provider.of<SharedPrefsRepository>(
      context,
      listen: false,
    );
    await sharedPrefsRepository.setRefreshTokenExpired(false);
    if (mounted) {
      setState(() {
        _isRefreshTokenExpired = false;
      });
    }
  }

  Future<String?> _getUserId() async {
    try {
      final secureStorageService = Provider.of<SecureStorageService>(
        context,
        listen: false,
      );
      
      var x = await secureStorageService.getUserId();
      return x;
    } catch (e) {
      return 'Error loading ID';
    }
  }

  Future<void> _copyUserId() async {
    try {
      final userId = await _getUserId();
      if (userId != null && userId != 'Error loading ID') {
        await Clipboard.setData(ClipboardData(text: userId));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)?.userIdCopied ?? 'User ID copied to clipboard',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)?.copyError ?? 'Error copying User ID',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _clearSecureStorage() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.deleteAccount ?? 'Delete Account',
          ),
          content: Text(
            AppLocalizations.of(context)?.deleteAccountConfirmation ??
                'Are you sure you want to delete your account? All your collaborations will be permanently deleted and cannot be recovered.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                AppLocalizations.of(context)?.cancel ?? 'Cancel',
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(
                AppLocalizations.of(context)?.delete ?? 'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      final secureStorageService = Provider.of<SecureStorageService>(
        context,
        listen: false,
      );
      final apiService = Provider.of<CollaborationsApiService>(
        context,
        listen: false,
      );
      
      try {
        await apiService.deleteAll();
        await secureStorageService.clearAllSecureData();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)?.accountDeleted ??
                    'Account deleted successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)?.deleteAccountError ??
                    'Error deleting account: $e',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
