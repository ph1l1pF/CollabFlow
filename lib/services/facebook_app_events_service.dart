import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

class FacebookAppEventsService {
  final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();

  /// Track app activation/install event
  /// This is automatically called when the app is first opened
  /// Meta Ads can use this event to optimize for app installs
  Future<void> logActivateApp() async {
    try {
      await _facebookAppEvents.logEvent(
        name: 'fb_mobile_activate_app',
        parameters: {},
      );
    } catch (e) {
      // Silently fail to avoid breaking app functionality
      debugPrint('Facebook App Events: Failed to log activate app: $e');
    }
  }

  /// Track app open event
  /// Call this when the app comes to foreground
  Future<void> logAppOpen() async {
    try {
      await _facebookAppEvents.logEvent(
        name: 'fb_mobile_activate_app',
        parameters: {},
      );
    } catch (e) {
      print('Facebook App Events: Failed to log app open: $e');
    }
  }

  /// Track custom event for Meta Ads optimization
  /// Use this to track important user actions that you want to optimize for
  Future<void> logEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _facebookAppEvents.logEvent(
        name: eventName,
        parameters: parameters ?? {},
      );
    } catch (e) {
      debugPrint('Facebook App Events: Failed to log event $eventName: $e');
    }
  }

  /// Track complete registration event (Standard Meta Event)
  /// This is a standard event that Meta Ads can optimize for
  /// Use this when a user completes onboarding or creates their first collaboration
  Future<void> logCompleteRegistration({
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _facebookAppEvents.logEvent(
        name: 'fb_mobile_complete_registration',
        parameters: parameters ?? {},
      );
    } catch (e) {
      debugPrint('Facebook App Events: Failed to log complete registration: $e');
    }
  }

  /// Track purchase event (Standard Meta Event)
  /// Use this for transactions or important conversions
  Future<void> logPurchase({
    required double amount,
    String? currency,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final params = <String, dynamic>{
        'fb_currency': currency ?? 'EUR',
        'fb_value': amount,
        ...?parameters,
      };
      await _facebookAppEvents.logEvent(
        name: 'fb_mobile_purchase',
        parameters: params,
      );
    } catch (e) {
      debugPrint('Facebook App Events: Failed to log purchase: $e');
    }
  }
}

