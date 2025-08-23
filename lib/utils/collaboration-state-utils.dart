import 'package:collabflow/models/collaboration.dart';
import 'package:flutter/material.dart';

class CollaborationStateUtils {
  static IconData getStateIcon(CollabState state) {
    switch (state) {
      case CollabState.FirstTalks:
        return Icons.mark_chat_unread;
      case CollabState.ContractToSign:
        return Icons.assignment;
      case CollabState.ScriptToProduce:
        return Icons.edit_document;
      case CollabState.InProduction:
        return Icons.movie_creation;
      case CollabState.ContentEditing:
        return Icons.edit;
      case CollabState.ContentFeedback:
        return Icons.rate_review;
      case CollabState.Finished:
        return Icons.verified;
      default:
        return Icons.help_outline;
    }
  }

  static String getStateLabel(CollabState state) {
    switch (state) {
      case CollabState.FirstTalks:
        return "Erstgespräch";
      case CollabState.ContractToSign:
        return "Vertrag zu unterschreiben";
      case CollabState.ScriptToProduce:
        return "Skript erstellen";
      case CollabState.InProduction:
        return "In Produktion";
      case CollabState.ContentEditing:
        return "Content bearbeiten";
      case CollabState.ContentFeedback:
        return "Feedback für Content";
      case CollabState.Finished:
        return "Abgeschlossen";
      default:
        return "Unbekannt";
    }
  }
}
