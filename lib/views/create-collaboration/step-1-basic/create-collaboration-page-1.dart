import 'package:ugcworks/utils/collaboration-state-utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ugcworks/models/collaboration.dart';
import 'package:ugcworks/l10n/app_localizations.dart';
import 'package:ugcworks/constants/app_colors.dart';
import 'package:ugcworks/utils/theme_utils.dart';

class BasicCollaborationStep extends StatefulWidget {
  final void Function({
    required String title,
    required String description,
    required Deadline deadline,
    required double fee,
    required CollabState state,
    required bool next,
  }) onNext;

  final String initialTitle;
  final String initialDescription;
  final Deadline initialDeadline;
  final double initialFee;
  final CollabState initialState;

  final String? confirmButtonLabel;
  final String? cancelButtonLabel;

  BasicCollaborationStep({
    super.key,
    required this.onNext,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialDeadline,
    required this.initialFee,
    required this.initialState,
    this.confirmButtonLabel,
    this.cancelButtonLabel,
  });

  @override
  State<BasicCollaborationStep> createState() => _BasicCollaborationStepState();
}

class _BasicCollaborationStepState extends State<BasicCollaborationStep> {
  final _formKey = GlobalKey<FormState>();
  final _timelineController = ScrollController();

  late String _title;
  late String _description;
  late Deadline _deadline;
  late double _fee;
  late CollabState _state;
  bool _notifyOnDeadline = true;

  @override
  void initState() {
    super.initState();
    _title = widget.initialTitle;
    _description = widget.initialDescription;
    _deadline = widget.initialDeadline;
    _fee = widget.initialFee;
    _state = widget.initialState;
    _notifyOnDeadline = _deadline.sendNotification;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedState();
    });
  }

  void _scrollToSelectedState() {
    final index = CollabState.values.indexOf(_state);
    final offset = (index * 160.0) - (MediaQuery.of(context).size.width / 2) + 40.0;
    _timelineController.animateTo(
      offset.clamp(0, _timelineController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline.date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _deadline.date = picked;
      });
    }
  }

  void _goNext() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.onNext(
        next: true,
        title: _title,
        description: _description,
        deadline: _deadline,
        fee: _fee,
        state: _state,
      );
    }
  }

  void _goBack() {
    _formKey.currentState?.save();
    widget.onNext(
      next: false,
      title: _title,
      description: _description,
      deadline: _deadline,
      fee: _fee,
      state: _state,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ThemeUtils.getBackgroundDecoration(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(AppLocalizations.of(context)?.edit ?? 'Edit'),
          elevation: 0,
        ),
        body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.title ?? 'Collaboration title *',
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? (AppLocalizations.of(context)?.enterTitle ?? 'Enter title') : null,
              onSaved: (val) => _title = val ?? '',
              initialValue: widget.initialTitle,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event, color: AppColors.primaryPink),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)?.deadlineAndNotification ?? 'Deadline & Notification',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(AppLocalizations.of(context)?.deadline ?? "Deadline"),
                    subtitle: Text(DateFormat.yMd(Localizations.localeOf(context).toString()).format(_deadline.date)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _pickDeadline,
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(AppLocalizations.of(context)?.notify ?? "Notify"),
                    value: _notifyOnDeadline,
                    onChanged: (val) {
                      setState(() {
                        _notifyOnDeadline = val;
                        _deadline.sendNotification = val;
                      });
                    },
                  ),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)?.daysBefore ?? "Days(s) before",
                    ),
                    value: _deadline.notifyDaysBefore,
                    items: [1, 2, 3, 5, 7].map((days) {
                      return DropdownMenuItem(
                        value: days,
                        child: Text("$days ${days == 1 ? (AppLocalizations.of(context)?.dayBefore ?? "day before") : (AppLocalizations.of(context)?.daysBefore ?? "days before")}"),
                      );
                    }).toList(),
                    onChanged: _notifyOnDeadline
                        ? (days) {
                            if (days != null) {
                              setState(() {
                                _deadline.notifyDaysBefore = days;
                              });
                            }
                          }
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.fee ?? 'Fee (optional)',
                prefixText: '€ ',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (val) {
                if (val == null || val.isEmpty) return null;
                final fee = double.tryParse(val.replaceAll(',', '.'));
                if (fee == null || fee < 0) return AppLocalizations.of(context)?.enterValidAmount ?? 'Enter valid amount';
                return null;
              },
              onSaved: (val) =>
                  _fee = double.tryParse(val!.replaceAll(',', '.')) ?? 0,
              initialValue:
                  widget.initialFee > 0 ? widget.initialFee.toString() : null,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.status ?? 'Status',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _timelineController,
              child: Row(
                children: CollabState.values.map((state) {
                  final isSelected = _state == state;
                  final icon = CollaborationStateUtils.getStateIcon(state);
                  final label = CollaborationStateUtils.getStateLabel(state, context);

                  return GestureDetector(
                    onTap: () {
                      setState(() => _state = state);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToSelectedState();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryPinkWithOpacity : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryPink : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(icon, color: isSelected ? AppColors.primaryPink : Colors.grey[500]),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: TextStyle(
                              color: isSelected ? AppColors.primaryPink : Colors.grey[600],
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _goBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          widget.cancelButtonLabel ?? (AppLocalizations.of(context)?.cancel ?? 'Cancel'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _goNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.confirmButtonLabel ?? (AppLocalizations.of(context)?.next ?? 'Next'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}
