import 'package:flutter/material.dart';
import 'package:ugcworks/models/collaboration.dart';
import 'package:ugcworks/repositories/collaborations-repository.dart';

enum TimePeriod {
  week,
  month,
  year,
  overall,
}

class DashboardViewModel extends ChangeNotifier {
  final CollaborationsRepository _collaborationsRepository;
  TimePeriod _selectedTimePeriod = TimePeriod.overall;

  DashboardViewModel({
    required CollaborationsRepository collaborationsRepository,
  }) : _collaborationsRepository = collaborationsRepository {
    _collaborationsRepository.addListener(_onRepositoryChanged);
  }

  TimePeriod get selectedTimePeriod => _selectedTimePeriod;

  void setTimePeriod(TimePeriod period) {
    _selectedTimePeriod = period;
    notifyListeners();
  }

  void _onRepositoryChanged() {
    notifyListeners();
  }

  List<Collaboration> get collaborations => _collaborationsRepository.collaborations;

  // Filter collaborations by selected time period
  List<Collaboration> get _filteredCollaborations {
    final now = DateTime.now();
    final filtered = collaborations.where((collab) {
      switch (_selectedTimePeriod) {
        case TimePeriod.week:
          final weekAgo = now.subtract(const Duration(days: 7));
          return collab.deadline.date.isAfter(weekAgo);
        case TimePeriod.month:
          final monthAgo = DateTime(now.year, now.month - 1, now.day);
          return collab.deadline.date.isAfter(monthAgo);
        case TimePeriod.year:
          final yearAgo = DateTime(now.year - 1, now.month, now.day);
          return collab.deadline.date.isAfter(yearAgo);
        case TimePeriod.overall:
          return true;
      }
    }).toList();
    return filtered;
  }

  // Total earnings calculation
  double get totalEarnings {
    return _filteredCollaborations
        .where((collab) => collab.state == CollabState.Finished)
        .fold(0.0, (sum, collab) => sum + collab.fee.amount);
  }

  // Total collaborations count
  int get totalCollaborations => _filteredCollaborations.length;

  // Active collaborations count
  int get activeCollaborations {
    return _filteredCollaborations
        .where((collab) => collab.state != CollabState.Finished)
        .length;
  }

  // Completed collaborations count
  int get completedCollaborations {
    return _filteredCollaborations
        .where((collab) => collab.state == CollabState.Finished)
        .length;
  }

  // Highest paid collaboration
  Collaboration? get highestPaidCollaboration {
    final finishedCollabs = _filteredCollaborations
        .where((collab) => collab.state == CollabState.Finished)
        .toList();
    
    if (finishedCollabs.isEmpty) return null;
    
    return finishedCollabs.fold<Collaboration?>(null, (highest, collab) {
      if (highest == null) return collab;
      return collab.fee.amount > highest.fee.amount ? collab : highest;
    });
  }

  // Check if there are any collaborations
  bool get hasCollaborations => _filteredCollaborations.isNotEmpty;

  @override
  void dispose() {
    _collaborationsRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
