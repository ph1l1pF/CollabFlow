// --- deine Klassen vereinfachtes Beispiel ---
import 'dart:collection';

import 'package:collabflow/repositories/collaborations-repository.dart';

class CollaborationsListViewModel {

  final CollaborationsRepository _collaborationsRepository;

  CollaborationsListViewModel({
    required CollaborationsRepository collaborationsRepository
  }): _collaborationsRepository = collaborationsRepository;

    UnmodifiableListView<CollaborationSmallViewModel> get collaborations => UnmodifiableListView(_collaborationsRepository.collaborations.map((collab) {
      return CollaborationSmallViewModel(
        title: collab.title,
        deadline: collab.deadline,
        partner: collab.partner?.companyName ?? 'Unbekannte Brand',
      );
    }).toList());

}

class CollaborationSmallViewModel {
  final String title;
  final DateTime deadline;
  final String partner;

  CollaborationSmallViewModel({
    required this.title,
    required this.deadline,
    required this.partner,
  });

}
