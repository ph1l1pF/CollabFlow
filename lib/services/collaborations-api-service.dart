import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:collabflow/models/collaboration.dart';
import 'package:collabflow/services/secure-storage-service.dart';
import 'package:collabflow/repositories/collaborations-repository.dart';
import 'package:collabflow/repositories/shared-prefs-repository.dart';
import 'package:collabflow/constants/api_config.dart';

class CollaborationsApiService {
  final SecureStorageService _secureStorageService;
  final CollaborationsRepository _collaborationsRepository;
  final SharedPrefsRepository _sharedPrefsRepository;
  Timer? _syncTimer;
  bool _isSyncing = false;
  
  
  CollaborationsApiService({
    required SecureStorageService secureStorageService,
    required CollaborationsRepository collaborationsRepository,
    required SharedPrefsRepository sharedPrefsRepository,
  }) : _secureStorageService = secureStorageService,
       _collaborationsRepository = collaborationsRepository,
       _sharedPrefsRepository = sharedPrefsRepository;

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
      
      final baseUrl = await ApiConfig.baseUrl;
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
        await _sharedPrefsRepository.setRefreshTokenExpired(true);
        return false;
      }

      final baseUrl = await ApiConfig.baseUrl;
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
        
        // Clear the expired flag since we successfully refreshed
        await _sharedPrefsRepository.setRefreshTokenExpired(false);
        
        print("Token refreshed successfully");
        return true;
      } else if (response.statusCode == 401) {
        // Refresh token is expired
        print("Refresh token expired, user needs to re-login");
        await _sharedPrefsRepository.setRefreshTokenExpired(true);
        return false;
      } else {
        print("Failed to refresh token: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error refreshing token: $e");
      await _sharedPrefsRepository.setRefreshTokenExpired(true);
      return false;
    }
  }

  /// Convert server JSON to Collaboration object
  Collaboration _jsonToCollaboration(Map<String, dynamic> json) {
    return Collaboration(
      title: json['title'] as String,
      deadline: Deadline(
        date: DateTime.parse(json['deadline']['date'] as String),
        sendNotification: json['deadline']['sendNotification'] as bool,
        notifyDaysBefore: json['deadline']['notifyDaysBefore'] as int?,
      ),
      fee: Fee(
        amount: (json['fee']['amount'] as num).toDouble(),
        currency: json['fee']['currency'] as String,
      ),
      requirements: Requirements(
        requirements: [],
      ),
      partner: Partner(
        name: json['partner']['name'] as String,
        email: json['partner']['email'] as String,
        phone: json['partner']['phone'] as String,
        companyName: json['partner']['companyName'] ?? '',
        industry: json['partner']['industry'] ?? '',
        customerNumber: json['partner']['customerNumber'] ?? '',
      ),
      script: Script(
        content: json['script']['content'] as String,
      ),
      notes: json['notes'] as String,
      state: _parseCollabState(json['state'] as String),
      isDirty: false, // Server data is clean
    )..id = json['id'] as String; // Set the ID from server
  }

  /// Parse CollabState from string
  CollabState _parseCollabState(String stateString) {
    switch (stateString) {
      case 'FirstTalks':
        return CollabState.FirstTalks;
      case 'ContractToSign':
        return CollabState.ContractToSign;
      case 'ScriptToProduce':
        return CollabState.ScriptToProduce;
      case 'InProduction':
        return CollabState.InProduction;
      case 'ContentEditing':
        return CollabState.ContentEditing;
      case 'ContentFeedback':
        return CollabState.ContentFeedback;
      case 'Finished':
        return CollabState.Finished;
      default:
        return CollabState.FirstTalks; // Default fallback
    }
  }

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

  Future<void> fetchAndSyncAllCollaborations() async {
    try {
      final accessToken = await _secureStorageService.getAuthAccessToken();
      if (accessToken == null) {
        print("No access token available for fetching collaborations");
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final baseUrl = await ApiConfig.baseUrl;
      final response = await http.get(
        Uri.parse('$baseUrl/collaborations'),
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> serverCollaborations = jsonDecode(response.body);
        
        await _syncServerCollaborations(serverCollaborations);
      } else if (response.statusCode == 401) {
        final refreshSuccess = await _refreshToken();
        if (refreshSuccess) {
          // Retry the request with new token
          await fetchAndSyncAllCollaborations();
        }
      } else {
      }
    } on TimeoutException {
      print("Timeout fetching collaborations from server");
    } catch (e) {
      print("Error fetching collaborations: $e");
    }
  }

  Future<void> _syncServerCollaborations(List<dynamic> serverCollaborations) async {
    try {
      final localCollaborations = _collaborationsRepository.collaborations;
      final localIds = localCollaborations.map((c) => c.id).toSet();
      
      int addedCount = 0;
      
      for (final serverCollabData in serverCollaborations) {
        final serverId = serverCollabData['id'] as String;
        
        // Only add if not already exists locally
        if (!localIds.contains(serverId)) {
          try {
            final collaboration = _jsonToCollaboration(serverCollabData);
            // Mark as clean since it came from server
            collaboration.isDirty = false;
            
            // Add to local repository
            _collaborationsRepository.addCollaborationFromServer(collaboration);
            addedCount++;
            
            print("Added collaboration from server: ${collaboration.title}");
          } catch (e) {
            print("Error parsing server collaboration $serverId: $e");
          }
        }
      }
      
      print("Sync completed: Added $addedCount new collaborations from server");
    } catch (e) {
      print("Error syncing server collaborations: $e");
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

  Future<void> deleteAll() async {
    try {
      
      final accessToken = await _secureStorageService.getAuthAccessToken();
      if (accessToken == null) {
        throw Exception("No access token available");
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final baseUrl = await ApiConfig.baseUrl;
      
      final response = await http.delete(
        Uri.parse('$baseUrl/collaborations'),
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 204) {
        
        // Clear local storage after successful API call
        _collaborationsRepository.clearAll();
      } else if (response.statusCode == 401) {
        final refreshSuccess = await _refreshToken();
        if (refreshSuccess) {
          // Retry the delete request with new token
          await deleteAll();
        } else {
          throw Exception("Token refresh failed");
        }
      } else {
        throw Exception("Failed to delete collaborations: ${response.statusCode}");
      }
    } on TimeoutException {
      throw Exception("Timeout deleting collaborations");
    } catch (e) {
      rethrow;
    }
  }
}
