import 'package:collabflow/models/collaboration.dart';
import 'package:collabflow/repositories/collaborations-repository.dart';
import 'package:collabflow/views/create-collaboration/step-1-basic/create-collaboration-page-1.dart';
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

  Partner? _partner;

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

  void _previousStep() {
    setState(() => _currentStep--);
  }

  void _handleBasicInfo({
    required bool next,
    required String title,
    required String description,
    required DateTime deadline,
  }) {
    if(!next) {
      Navigator.of(context).pop();
      return;
    }
    _title = title;
    _description = description;
    _deadline = deadline;
    
    _nextStep();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Builder(
          builder: (context) {
            switch (_currentStep) {
              case 0:
                return BasicCollaborationStep(
                  onNext: _handleBasicInfo,
                  initialTitle: _title ?? '',
                  initialDescription: _description ?? '',
                  initialDeadline: _deadline ?? DateTime.now(),
                );
              case 1:
                return ScriptStep(
                  onNext: _handleScriptStep,
                  initialScriptContent: _scriptContent ?? '',
                  initialNotes: _notes ?? '',
                );
              case 2:
                return PartnerStep(
                  onFinish: _handlePartnerStep,
                  initialName: _partner?.name ?? '',
                  initialEmail: _partner?.email ?? '',
                  initialPhone: _partner?.phone ?? '',
                  initialCompanyName: _partner?.companyName ?? '',
                  initialIndustry: _partner?.industry ?? '',
                  initialCustomerNumber: _partner?.customerNumber ?? '',
                  );
              default:
                throw Exception("Unknown step $_currentStep");
            }
          },
        ),
      ),
    );
  }

  void _handlePartnerStep(Partner partner, bool next) {
    _partner = partner;

    if(!next){
      _previousStep();
      return;
    }

    final collab = Collaboration(
      title: _title!,
      deadline: _deadline!,
      //platforms: [],
      fee: Fee(amount: 0, currency: 'EUR'),
      //state: CollabState.Accepted,
      requirements: Requirements(requirements: [_notes ?? '']),
      partner: _partner ?? Partner(
        name: '',
        email: '',
        phone: '',
        companyName: '',
        industry: '',
        customerNumber: '',
      ),
      script: Script(content: _scriptContent ?? ''),
      notes: _notes ?? '',
    );
    _collaborationsRepository.createCollaboration(collab);

    Navigator.of(context).pop();
  }

  void _handleScriptStep( {
    required String scriptContent,
    required String notes,
    required bool next
  }) {
    _scriptContent = scriptContent;
    _notes = notes;

    if(next ){
    _nextStep();
    }
    else {
      _previousStep();
    }
  }
}
