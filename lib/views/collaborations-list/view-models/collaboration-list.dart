// --- deine Klassen vereinfachtes Beispiel ---
import 'dart:collection';

import 'package:collabflow/repositories/collaborations-repository.dart';
import 'package:flutter/material.dart';

class CollaborationsListViewModel extends ChangeNotifier{

  final CollaborationsRepository _collaborationsRepository;

  CollaborationsListViewModel({
    required CollaborationsRepository collaborationsRepository
  }): _collaborationsRepository = collaborationsRepository;

    UnmodifiableListView<CollaborationSmallViewModel> get collaborations => UnmodifiableListView(_collaborationsRepository.collaborations.map((collab) {
      return CollaborationSmallViewModel(
        title: collab.title,
        deadline: collab.deadline,
        partner: collab.partner?.companyName ?? 'Unbekannte Brand',
        id: collab.id,
      );
    }).toList());

}

class CollaborationSmallViewModel {
  final String title;
  final DateTime deadline;
  final String partner;
  final String id;

  CollaborationSmallViewModel({
    required this.title,
    required this.deadline,
    required this.partner,
    required this.id
  });

}
