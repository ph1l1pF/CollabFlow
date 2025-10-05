import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ugcworks/l10n/app_localizations.dart';
import 'package:ugcworks/constants/app_colors.dart';

class ReviewPopup extends StatelessWidget {
  const ReviewPopup({super.key});

  static Future<void> show(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => const ReviewPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Star rating icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.star_rate,
                size: 32,
                color: AppColors.primaryPink,
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              AppLocalizations.of(context)?.enjoyingApp ?? 'Enjoying UGCWorks?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            Text(
              AppLocalizations.of(context)?.reviewMessage ?? 
                  'We would love to hear your feedback! Your review helps us improve and reach more creators.',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      AppLocalizations.of(context)?.notNow ?? 'Not now',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _openAppStoreReview();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)?.rateApp ?? 'Rate App',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }

  Future<void> _openAppStoreReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    try {
      // Try to open the in-app review flow
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        return;
      }

      // Fallback 1: Open App Store listing directly (needs appStoreId on iOS)
      try {
        await inAppReview.openStoreListing(appStoreId: '6753014313');
        return;
      } catch (_) {/* continue to next fallback */}

      // Fallback 2: Deep link to write-review page via itms-apps (iOS)
      // This is more reliable on TestFlight where requestReview may be ignored
      const itmsUrl = 'itms-apps://itunes.apple.com/app/id6753014313?action=write-review';
      await launchUrl(Uri.parse(itmsUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      // Final fallback: open HTTPS URL (may open in Safari if App Store not reachable)
      const httpsUrl = 'https://apps.apple.com/app/id6753014313?action=write-review';
      try {
        await launchUrl(Uri.parse(httpsUrl), mode: LaunchMode.externalApplication);
      } catch (_) {
        // Swallow as last resort
      }
    }
  }
}
