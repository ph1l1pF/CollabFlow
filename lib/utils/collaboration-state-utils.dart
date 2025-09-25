import 'package:ugcworks/models/collaboration.dart';
import 'package:flutter/material.dart';
import 'package:ugcworks/l10n/app_localizations.dart';

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
    }
  }

  static String getStateLabel(CollabState state, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (state) {
      case CollabState.FirstTalks:
        return l10n?.firstTalks ?? "First talks";
      case CollabState.ContractToSign:
        return l10n?.contractToSign ?? "Contract to sign";
      case CollabState.ScriptToProduce:
        return l10n?.scriptToProduce ?? "Create script";
      case CollabState.InProduction:
        return l10n?.inProduction ?? "In production";
      case CollabState.ContentEditing:
        return l10n?.contentEditing ?? "Content editing";
      case CollabState.ContentFeedback:
        return l10n?.contentFeedback ?? "Content feedback";
      case CollabState.Finished:
        return l10n?.finished ?? "Finished";
    }
  }
}
