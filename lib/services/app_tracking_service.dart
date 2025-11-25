import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';

class AppTrackingService {
  /// Check if tracking authorization status is available
  /// Returns true if the system supports tracking authorization
  Future<bool> isTrackingAvailable() async {
    try {
      await AppTrackingTransparency.trackingAuthorizationStatus;
      return true;
    } catch (e) {
      debugPrint('App Tracking Transparency not available: $e');
      return false;
    }
  }

  /// Get current tracking authorization status
  /// Returns the current authorization status
  Future<TrackingStatus> getTrackingStatus() async {
    try {
      return await AppTrackingTransparency.trackingAuthorizationStatus;
    } catch (e) {
      debugPrint('Error getting tracking status: $e');
      return TrackingStatus.notDetermined;
    }
  }

  /// Check if tracking is already authorized
  /// Returns true if tracking is authorized, false otherwise
  Future<bool> isTrackingAuthorized() async {
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      return status == TrackingStatus.authorized;
    } catch (e) {
      debugPrint('Error checking tracking authorization: $e');
      return false;
    }
  }

  /// Request tracking authorization
  /// Shows the native iOS tracking permission dialog
  /// Returns the authorization status after user responds
  Future<TrackingStatus> requestTrackingPermission() async {
    try {
      final status = await AppTrackingTransparency.requestTrackingAuthorization();
      debugPrint('Tracking authorization status: $status');
      return status;
    } catch (e) {
      debugPrint('Error requesting tracking permission: $e');
      return TrackingStatus.notDetermined;
    }
  }
}

