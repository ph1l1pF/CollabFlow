import 'package:ugcworks/repositories/notifications-repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ugcworks/constants/app_colors.dart';
import 'package:ugcworks/utils/theme_utils.dart';

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
        const SnackBar(content: Text("Benachrichtigungen aktiviert ✅")),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Benachrichtigungen nicht erlaubt ❌")),
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
              const Text(
                "Glückwunsch 🎉",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Du hast deine erste Collaboration angelegt!\n\n"
                "Damit du keine Deadline mehr verpasst, "
                "kannst du dich automatisch erinnern lassen.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _requestPermission(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Ja, erinnert mich"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Nein, vielleicht später"),
              )
            ],
          ),
        ),
      ),
      ),
    );
  }
}
