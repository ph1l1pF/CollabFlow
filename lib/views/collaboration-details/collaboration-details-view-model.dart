import 'package:ugcworks/models/collaboration.dart';
import 'package:ugcworks/repositories/collaborations-repository.dart';
import 'package:flutter/material.dart';

class CollaborationDetailsViewModel {
  late Collaboration collab;

  final CollaborationsRepository _collaborationsRepository;

  CollaborationDetailsViewModel({
    required CollaborationsRepository collaborationsRepository,
    required String collabId,
  }) : _collaborationsRepository = collaborationsRepository {
    collab = _collaborationsRepository.collaborations.firstWhere(
      (c) => c.id == collabId,
      orElse: () => throw Exception("Collaboration not found"),
    );
  }

  void deleteCollaboration() {
    _collaborationsRepository.delete(collab);
  }

  void updateCollaboration(Collaboration updatedCollaboration, {BuildContext? context}){
    _collaborationsRepository.updateCollaboration(updatedCollaboration, context: context);
  }

}