import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ugcworks/services/secure-storage-service.dart';

class OnboardingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SecureStorageService _secureStorage = SecureStorageService();

  /// Get or create anonymous user ID
  Future<String> _getAnonymousUserId() async {
    // Try to get stored anonymous ID
    final storedId = await _secureStorage.getUserId();
    if (storedId != null && storedId.isNotEmpty) {
      return storedId;
    }
    
    // Generate new anonymous ID
    final anonymousId = 'anon_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (9999 - 1000) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).round()}';
    await _secureStorage.storeUserId(anonymousId);
    return anonymousId;
  }


  /// Save onboarding responses to Firestore (anonymously)
  /// 
  /// Data structure:
  /// {
  ///   'collaborationsLast3Months': '1-3',
  ///   'timePerWeek': '< 30 Minuten',
  ///   'stressfulAspects': ['Deadlines im Blick behalten', 'Überblick über laufende Projekte'],
  ///   'organizationMethods': ['Excel', 'Notizen-App'],
  ///   'completedAt': Timestamp,
  /// }
  Future<void> saveOnboardingData(Map<String, dynamic> data) async {
    try {
      final userId = await _getAnonymousUserId();
      
      
      await _firestore.collection('onboarding_responses').doc(userId).set({
        ...data,
        'userId': userId,
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      debugPrint('Onboarding data saved successfully (anonymous, in English): $userId');
    } catch (e) {
      debugPrint('Error saving onboarding data: $e');
      rethrow;
    }
  }

  /// Get onboarding data for current user
  Future<Map<String, dynamic>?> getOnboardingData() async {
    try {
      final userId = await _getAnonymousUserId();
      final doc = await _firestore
          .collection('onboarding_responses')
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      debugPrint('Error getting onboarding data: $e');
      return null;
    }
  }

  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding() async {
    try {
      final data = await getOnboardingData();
      return data != null && data['completedAt'] != null;
    } catch (e) {
      debugPrint('Error checking onboarding status: $e');
      return false;
    }
  }
}

