import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:collabflow/models/collaboration.dart';
import 'package:collabflow/services/secure-storage-service.dart';
import 'package:collabflow/repositories/collaborations-repository.dart';

class CollaborationsApiService {
  final String baseUrl = "http://192.168.68.100:5066";
  final SecureStorageService _secureStorageService;
  final CollaborationsRepository _collaborationsRepository;
  Timer? _syncTimer;
  bool _isSyncing = false;
  
  CollaborationsApiService({
    required SecureStorageService secureStorageService,
    required CollaborationsRepository collaborationsRepository,
  }) : _secureStorageService = secureStorageService,
       _collaborationsRepository = collaborationsRepository;

  /// Start periodic sync of dirty collaborations
  void startPeriodicSync({Duration interval = const Duration(seconds: 5)}) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) {
      if (_getDirtyCount() > 0) {
        _syncDirtyCollaborations();
      }
      else {
        print("No dirty collaborations to sync");
      }
    });
  }

  /// Stop periodic sync
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Sync all dirty collaborations with the backend
  Future<void> _syncDirtyCollaborations() async {
    // Prevent multiple concurrent syncs
    if (_isSyncing) {
      print("Sync already in progress, skipping...");
      return;
    }

    try {
      _isSyncing = true;
      
      final dirtyCollaborations = _collaborationsRepository.collaborations
          .where((collab) => collab.isDirty)
          .toList();

      if (dirtyCollaborations.isEmpty) {
        print("No dirty collaborations to sync");
        return;
      }

      print("Syncing ${dirtyCollaborations.length} dirty collaborations");

      // Process in batches to avoid memory issues
      const batchSize = 5;
      for (int i = 0; i < dirtyCollaborations.length; i += batchSize) {
        final batch = dirtyCollaborations.skip(i).take(batchSize);
        for (final collaboration in batch) {
          await _syncSingleCollaboration(collaboration);
        }
        
        // Small delay between batches to prevent overwhelming the system
        if (i + batchSize < dirtyCollaborations.length) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
    } catch (e) {
      print("Error during sync: $e");
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync a single collaboration with the backend
  Future<void> _syncSingleCollaboration(Collaboration collaboration) async {
    try {
      final accessToken = await _secureStorageService.getAuthAccessToken();
      if (accessToken == null) {
        print("No access token available for sync");
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final collaborationData = _collaborationToJson(collaboration);
      
      // Try to create/update the collaboration with timeout
      final response = await http.put(
        Uri.parse('$baseUrl/collaborations'),
        headers: headers,
        body: jsonEncode(collaborationData),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success - mark as clean
        collaboration.isDirty = false;
        _collaborationsRepository.updateCollaboration(collaboration, setIsDirty: false);
        print("Successfully synced collaboration: ${collaboration.title}");
      } else if (response.statusCode == 401) {
        // Unauthorized - try to refresh token
        print("Token expired, attempting refresh...");
        final refreshSuccess = await _refreshToken();
        if (refreshSuccess) {
          // Retry the request with new token (only once to prevent infinite loops)
          await _syncSingleCollaboration(collaboration);
        }
      } else {
        print("Failed to sync collaboration ${collaboration.title}: ${response.statusCode} - ${response.body}");
      }
    } on TimeoutException {
      print("Timeout syncing collaboration ${collaboration.title}");
    } catch (e) {
      print("Error syncing collaboration ${collaboration.title}: $e");
    }
  }

  /// Refresh the access token using the refresh token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorageService.getAuthRefreshToken();
      if (refreshToken == null) {
        print("No refresh token available");
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['tokenResponse']['accessToken'] as String;
        final newRefreshToken = data['tokenResponse']['refreshToken'] as String;

        await _secureStorageService.storeAccessToken(newAccessToken);
        await _secureStorageService.storeRefreshToken(newRefreshToken);
        
        print("Token refreshed successfully");
        return true;
      } else {
        print("Failed to refresh token: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error refreshing token: $e");
      return false;
    }
  }

  /// Convert Collaboration object to JSON for API
  Map<String, dynamic> _collaborationToJson(Collaboration collaboration) {
    return {
      'id': collaboration.id,
      'title': collaboration.title,
      'deadline': {
        'date': collaboration.deadline.date.toIso8601String(),
        'sendNotification': collaboration.deadline.sendNotification,
        'notifyDaysBefore': collaboration.deadline.notifyDaysBefore,
      },
      'fee': {
        'amount': collaboration.fee.amount,
        'currency': collaboration.fee.currency,
      },
      'requirements': {
        'requirements': collaboration.requirements.requirements,
      },
      'partner': {
        'name': collaboration.partner.name,
        'email': collaboration.partner.email,
        'phone': collaboration.partner.phone,
      },
      'script': {
        'content': collaboration.script.content,
      },
      'notes': collaboration.notes,
      'state': collaboration.state.toString().split('.').last,
      'isDirty': collaboration.isDirty,
    };
  }

  /// Manually trigger sync (useful for testing or immediate sync)
  Future<void> syncNow() async {
    if (!_isSyncing) {
      await _syncDirtyCollaborations();
    } else {
      print("Sync already in progress, skipping manual sync");
    }
  }

  /// Get count of dirty collaborations
  int _getDirtyCount() {
    return _collaborationsRepository.collaborations
        .where((collab) => collab.isDirty)
        .length;
  }

  /// Dispose resources
  void dispose() {
    stopPeriodicSync();
    _isSyncing = false;
  }
}
