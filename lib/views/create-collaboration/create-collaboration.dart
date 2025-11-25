
import 'package:ugcworks/models/collaboration.dart';
import 'package:ugcworks/repositories/collaborations-repository.dart';
import 'package:ugcworks/repositories/notifications-repository.dart';
import 'package:ugcworks/repositories/shared-prefs-repository.dart';
import 'package:ugcworks/views/create-collaboration/step-1-basic/create-collaboration-page-1.dart';
import 'package:ugcworks/views/create-collaboration/create-collaboration-page-2.dart';
import 'package:ugcworks/views/create-collaboration/create-collaboration-page-3.dart';
import 'package:ugcworks/views/notification-permission/notification-permission.dart';
import 'package:ugcworks/services/review_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ugcworks/utils/theme_utils.dart';
import 'package:ugcworks/l10n/app_localizations.dart';
import 'package:ugcworks/services/analytics_service.dart';
import 'package:ugcworks/services/app_tracking_service.dart';
import 'package:ugcworks/widgets/tracking_permission_dialog.dart';

class CollaborationWizard extends StatefulWidget {
  const CollaborationWizard({super.key});

  @override
  State<CollaborationWizard> createState() => _CollaborationWizardState();
}

class _CollaborationWizardState extends State<CollaborationWizard> {
  late CollaborationsRepository _collaborationsRepository;
  late NotificationsRepository _notificationsRepository;

  String? _title;
  String? _description;
  Deadline? _deadline;
  double? _fee;
  CollabState _state = CollabState.FirstTalks;

  late SharedPrefsRepository _sharedPrefsRepository;

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
    _sharedPrefsRepository = Provider.of<SharedPrefsRepository>(
      context,
      listen: false,
    );
    _notificationsRepository = Provider.of<NotificationsRepository>(
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
    required Deadline deadline,
    required double fee,
    required CollabState state,
  }) {
    if (!next) {
      Navigator.of(context).pop();
      return;
    }
    _title = title;
    _description = description;
    _deadline = deadline;
    _fee = fee;
    _state = state;

    _nextStep();
  }


  Future<bool> _onWillPop() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.discardChanges ?? 'Discard changes?'),
        content: Text(AppLocalizations.of(context)?.discardChangesMessage ?? 'All entered data will be lost. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)?.discard ?? 'Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Container(
        decoration: ThemeUtils.getBackgroundDecoration(context),
        child: Scaffold(
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
                    initialDeadline: _deadline ?? Deadline.defaultDeadline(),
                    initialFee: _fee ?? 0,
                    initialState: _state,
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
        ),
      ),
    );
  }

  void _handlePartnerStep(Partner partner, bool next) async {
    _partner = partner;

    if (!next) {
      _previousStep();
      return;
    }

    final collab = Collaboration(
      title: _title!,
      deadline: _deadline!,
      fee: Fee(amount: _fee ?? 0, currency: 'EUR'),
      state: _state,
      requirements: Requirements(requirements: [_notes ?? '']),
      partner:
          _partner ??
          Partner(
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

    final isFirstCollaboration = await _sharedPrefsRepository.isFirstCollaboration();

    await _requestNotificationPermissionsIfNecessary(isFirstCollaboration);
    _collaborationsRepository.createCollaboration(collab, context: context);

    // Check if this is the first collaboration and request tracking permission
    if (isFirstCollaboration && mounted) {
      await _requestTrackingPermissionIfNeeded(context);
    }

    // Track collaboration creation for review popup
    Provider.of<ReviewService>(context, listen: false)
        .trackCollaborationCreated(context);
    // Analytics
    Provider.of<AnalyticsService>(context, listen: false).logCollaborationCreated(
      collabId: collab.id,
      state: collab.state.name,
    );

    // Show success toast
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.collaborationCreated ?? "Collaboration created successfully! ✅"),
          backgroundColor: Colors.green,
        ),
      );
    }

    Navigator.of(context).pop();
  }

  Future<void> _requestNotificationPermissionsIfNecessary(bool isFirstCollaboration) async {
    final enabled = await _notificationsRepository.notificationsEnabled();
    if (enabled) {
      return;
    }

    if (!isFirstCollaboration) {
      return;
    }
    await _sharedPrefsRepository.setIsFirstCollaboration();
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => NotificationPermissionScreen(),
      ),
    );
  }

  void _handleScriptStep({
    required String scriptContent,
    required String notes,
    required bool next,
  }) {
    _scriptContent = scriptContent;
    _notes = notes;

    if (next) {
      _nextStep();
    } else {
      _previousStep();
    }
  }

  Future<void> _requestTrackingPermissionIfNeeded(BuildContext context) async {
    final appTrackingService = Provider.of<AppTrackingService>(context, listen: false);
    
    // Check if tracking is already authorized
    final isAuthorized = await appTrackingService.isTrackingAuthorized();
    if (isAuthorized) {
      print('Tracking is already authorized');
      return; // Already authorized, no need to show dialog
    }

    // Check if tracking is available (iOS 14+)
    final isAvailable = await appTrackingService.isTrackingAvailable();
    if (!isAvailable) {
      print('Tracking is not available');
      return; // Tracking not available on this platform
    }

    // Show custom dialog first
    if (!mounted) return;
    
    final shouldRequest = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TrackingPermissionDialog(
        onOk: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );

    // If user clicked OK, show the native Apple tracking dialog
    if (shouldRequest == true && mounted) {
      await appTrackingService.requestTrackingPermission();
    }
  }
}
