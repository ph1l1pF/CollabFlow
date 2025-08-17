import 'package:collabflow/models/collaboration.dart';
import 'package:collabflow/repositories/collaborations-repository.dart';
import 'package:collabflow/views/create-collaboration/create-collaboration-page-1.dart';
import 'package:collabflow/views/create-collaboration/create-collaboration-page-2.dart';
import 'package:collabflow/views/create-collaboration/create-collaboration-page-3.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollaborationWizard extends StatefulWidget {
  const CollaborationWizard({super.key});

  @override
  State<CollaborationWizard> createState() => _CollaborationWizardState();
}

class _CollaborationWizardState extends State<CollaborationWizard> {
  late CollaborationsRepository _collaborationsRepository;

  String? _title;
  String? _description;
  DateTime? _deadline;

  String? _scriptContent;
  String? _notes;

  late Partner _partner;

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _collaborationsRepository = Provider.of<CollaborationsRepository>(
      context,
      listen: false,
    );
  }

  void _nextStep() {
    setState(() => _currentStep++);
  }

  void _handleBasicInfo({
    required String title,
    required String description,
    required DateTime deadline,
  }) {
    _title = title;
    _description = description;
    _deadline = deadline;
    _nextStep();
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return BasicCollaborationStep(onNext: _handleBasicInfo);
      case 1:
        return ScriptStep(onNext: _handleScriptStep);
      case 2:
        return PartnerStep(onNext: _handlePartnerStep);
      default:
        throw Exception("Unknown step $_currentStep");
    }
  }

  void _handlePartnerStep(Partner partner) {
    _partner = partner;
    final collab = Collaboration(
      title: _title!,
      deadline: _deadline!,
      platforms: [],
      fee: Fee(amount: 0, currency: 'EUR'),
      state: CollabState.Accepted,
      requirements: Requirements(requirements: [_notes ?? '']),
      partner: _partner,
      script: Script(content: _scriptContent ?? ''),
    );
    _collaborationsRepository.createCollaboration(collab);

    Navigator.of(context).pop();
  }

  void _handleScriptStep({
    required String scriptContent,
    required String notes,
  }) {
    _scriptContent = scriptContent;
    _notes = notes;
    _nextStep();
  }
}
