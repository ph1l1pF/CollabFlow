import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ugcworks/widgets/review_popup.dart';

/// Service to manage when to show the app review popup (instance-based)
/// Uses a combination of engagement metrics and positive moments
class ReviewService {
  static const String _keyAppLaunches = 'app_launches_count';
  static const String _keyPopupShown = 'review_pop_up_shown_already';

  ReviewService();

  /// Track app launches
  Future<void> trackAppLaunch(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_keyAppLaunches) ?? 0;
    await prefs.setInt(_keyAppLaunches, count + 1);

    // Show popup after 7 app launches (if not already shown)
    if (count == 6 && !(prefs.getBool(_keyPopupShown) ?? false)) {
      _schedulePopup(context);
    }
  }

  /// Track when user creates a collaboration
  Future<void> trackCollaborationCreated(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt('collaborations_created_count') ?? 0;
    await prefs.setInt('collaborations_created_count', count + 1);

    // Show popup after creating 5 collaborations
    if (count == 3 && !(prefs.getBool(_keyPopupShown) ?? false)) {
      _schedulePopup(context);
    }
  }

  /// Track when user finishes a collaboration (from "Finish" button)
  Future<void> trackCollaborationFinished(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // Use a single consistent key for read/write
    const key = 'collaborations_finished_count';
    final count = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, count + 1);

    // Show popup on first finish (count == 0 before increment)
    if (count == 0 && !(prefs.getBool(_keyPopupShown) ?? false)) {
      _schedulePopup(context);
    }
  }

  /// Track when user exports earnings successfully
  Future<void> trackEarningsExport(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt('earnings_exports_count') ?? 0;
    await prefs.setInt('earnings_exports_count', count + 1);

    // Show popup after first export (positive moment)
    if (count == 0 && !(prefs.getBool(_keyPopupShown) ?? false)) {
      _schedulePopup(context);
    }
  }

  void _schedulePopup(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_keyPopupShown) ?? false) return;

    // Mark as shown to ensure one-time prompt
    await prefs.setBool(_keyPopupShown, true);

    // Show popup shortly after the positive action
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        ReviewPopup.show(context);
      }
    });
  }
}
