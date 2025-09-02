import 'dart:collection';

import 'package:collabflow/repositories/collaborations-repository.dart';
import 'package:collabflow/utils/collaboration-state-utils.dart';
import 'package:flutter/material.dart';

class CollaborationsListViewModel extends ChangeNotifier {
  final CollaborationsRepository _collaborationsRepository;

  CollaborationsListViewModel({
    required CollaborationsRepository collaborationsRepository,
  }) : _collaborationsRepository = collaborationsRepository {
    _collaborationsRepository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    print("Repository changed, notifying listeners...");
    notifyListeners();
  }

  UnmodifiableListView<CollaborationSmallViewModel> get collaborations =>
      UnmodifiableListView(_collaborationsRepository.collaborations.map((collab) {
        return CollaborationSmallViewModel(
          title: collab.title,
          deadline: collab.deadline.date,
          partner: collab.partner?.companyName ?? 'Unbekannte Brand',
          id: collab.id,
          stateIcon: CollaborationStateUtils.getStateIcon(collab.state),
        );
      }).toList());

  @override
  void dispose() {
    _collaborationsRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}

class CollaborationSmallViewModel {
  final String title;
  final DateTime deadline;
  final String partner;
  final String id;
  final IconData stateIcon;

  CollaborationSmallViewModel({
    required this.title,
    required this.deadline,
    required this.partner,
    required this.id,
    required this.stateIcon,
  });
}
