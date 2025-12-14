import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
    } catch (_) {}
  }

  Future<void> logCollaborationCreated({required String collabId, String? state}) async {
    try {
      await _analytics.logEvent(
        name: 'collaboration_created',
        parameters: {
          'collab_id': collabId,
          if (state != null) 'state': state,
        },
      );
    } catch (_) {}
  }

  Future<void> logCollaborationFinished({required String collabId}) async {
    try {
      await _analytics.logEvent(
        name: 'collaboration_finished',
        parameters: {
          'collab_id': collabId,
        },
      );
    } catch (_) {}
  }

  Future<void> logEarningsExport({required String format, required int count}) async {
    try {
      await _analytics.logEvent(
        name: 'earnings_export',
        parameters: {
          'format': format,
          'entries': count,
        },
      );
    } catch (_) {print('Error logging earnings export:');}
  }

  Future<void> logFiltersApplied({required int selectedStatesCount}) async {
    try {
      await _analytics.logEvent(
        name: 'filters_applied',
        parameters: {
          'selected_states': selectedStatesCount,
        },
      );
    } catch (_) {}
  }

  Future<void> logOnboardingFinished() async {
    try {
      await _analytics.logEvent(name: 'onboarding_finished');
    } catch (_) {}
  }

  Future<void> logOnboardingSkipped() async {
    try {
      await _analytics.logEvent(name: 'onboarding_skipped');
    } catch (_) {}
  }
}


