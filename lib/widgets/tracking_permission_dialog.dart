import 'package:flutter/material.dart';
import 'package:ugcworks/l10n/app_localizations.dart';
import 'package:ugcworks/constants/app_colors.dart';

class TrackingPermissionDialog extends StatelessWidget {
  final VoidCallback onOk;
  final VoidCallback onCancel;

  const TrackingPermissionDialog({
    super.key,
    required this.onOk,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        localizations?.trackingPermissionTitle ?? 'Tracking erlauben?',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.trackingPermissionMessage ?? 
            'Wir möchten dir personalisierte Werbung zeigen, damit du relevante Angebote siehst. Dafür benötigen wir deine Erlaubnis zum Tracking.',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            localizations?.trackingPermissionInfo ??
            'Deine Daten werden sicher behandelt und nur für Werbezwecke verwendet.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            localizations?.cancel ?? 'Abbrechen',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onOk,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            localizations?.ok ?? 'OK',
          ),
        ),
      ],
    );
  }
}

