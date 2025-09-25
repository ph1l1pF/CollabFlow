import 'package:ugcworks/repositories/notifications-repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ugcworks/constants/app_colors.dart';
import 'package:ugcworks/utils/theme_utils.dart';
import 'package:ugcworks/l10n/app_localizations.dart';

class NotificationPermissionScreen extends StatelessWidget {

  const NotificationPermissionScreen({
    super.key
  });
  
  Future<void> _requestPermission(BuildContext context) async {
    final repo = Provider.of<NotificationsRepository>(context, listen: false);

    if(await repo.notificationsEnabled()){
      return;
    }

    final permissionsEnabled = await repo.requestPermission();

    if (permissionsEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.notificationsEnabled ?? "Notifications enabled ✅")),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.notificationsDenied ?? "Notifications not allowed ❌")),
      );
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ThemeUtils.getBackgroundDecoration(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.celebration, size: 80, color: AppColors.primaryPink),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)?.congratulations ?? "Congratulations 🎉",
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)?.firstCollaborationMessage ?? 
                "You have created your first collaboration!\n\n"
                "So you don't miss any deadlines, "
                "you can be automatically reminded.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _requestPermission(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  AppLocalizations.of(context)?.yesRemindMe ?? "Yes, remind me",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 8),
                ),
                child: Text(
                  AppLocalizations.of(context)?.noMaybeLater ?? "No, maybe later",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      ),
    );
  }
}
