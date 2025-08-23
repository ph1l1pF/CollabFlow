import 'package:collabflow/utils/collaboration-state-utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collabflow/models/collaboration.dart';

class BasicCollaborationStep extends StatefulWidget {
  final void Function({
    required String title,
    required String description,
    required DateTime deadline,
    required double fee,
    required CollabState state,
    required bool next,
  })
  onNext;
  final String initialTitle;
  final String initialDescription;
  final DateTime initialDeadline;
  final double initialFee;
  final CollabState initialState;
  String? confirmButtonLabel;
  String? cancelButtonLabel;

  BasicCollaborationStep({
    super.key,
    required this.onNext,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialDeadline,
    required this.initialFee,
    required this.initialState,
    this.confirmButtonLabel
  });

  @override
  State<BasicCollaborationStep> createState() => _BasicCollaborationStepState();
}

class _BasicCollaborationStepState extends State<BasicCollaborationStep> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _deadline;
  late double _fee;
  late CollabState _state;

  @override
  void initState() {
    super.initState();
    _title = widget.initialTitle;
    _description = widget.initialDescription;
    _deadline = widget.initialDeadline;
    _fee = widget.initialFee;
    _state = widget.initialState;
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
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
        state: _state
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
      state: _state
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basisdaten bearbeiten'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Titel der Kooperation (*)',
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? 'Titel eingeben' : null,
              onSaved: (val) => _title = val ?? '',
              initialValue: widget.initialTitle,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text("Deadline"),
              subtitle: Text(DateFormat('dd.MM.yyyy').format(_deadline)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDeadline,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Honorar (optional)',
                prefixText: '€ ',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (val) {
                if (val == null || val.isEmpty) return null;
                final fee = double.tryParse(val.replaceAll(',', '.'));
                if (fee == null || fee < 0) return 'Gültigen Betrag eingeben';
                return null;
              },
              onSaved: (val) => _fee = double.tryParse(val!.replaceAll(',', '.')) ?? 0,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CollabState>(
              value: _state,
              decoration: const InputDecoration(
                labelText: 'Status',
              ),
              items: CollabState.values.map((state) {
                IconData icon;
                String label;
                switch (state) {
                  case CollabState.FirstTalks:
                    icon = CollaborationStateUtils.getStateIcon(CollabState.FirstTalks);
                    label = CollaborationStateUtils.getStateLabel(CollabState.FirstTalks);
                    break;
                  case CollabState.ContractToSign:
                    icon = CollaborationStateUtils.getStateIcon(CollabState.ContractToSign);
                    label = CollaborationStateUtils.getStateLabel(CollabState.ContractToSign);
                    break;
                  case CollabState.ScriptToProduce:
                    icon = CollaborationStateUtils.getStateIcon(CollabState.ScriptToProduce);
                    label = CollaborationStateUtils.getStateLabel(CollabState.ScriptToProduce);
                    break;
                  case CollabState.InProduction:
                    icon = CollaborationStateUtils.getStateIcon(CollabState.InProduction);
                    label = CollaborationStateUtils.getStateLabel(CollabState.InProduction);
                    break;
                  case CollabState.ContentEditing:
                    icon = CollaborationStateUtils.getStateIcon(CollabState.ContentEditing);
                    label = CollaborationStateUtils.getStateLabel(CollabState.ContentEditing);
                    break;
                  case CollabState.ContentFeedback:
                    icon = CollaborationStateUtils.getStateIcon(CollabState.ContentFeedback);
                    label = CollaborationStateUtils.getStateLabel(CollabState.ContentFeedback);
                    break;
                  case CollabState.Finished:
                    icon = CollaborationStateUtils.getStateIcon(CollabState.Finished);
                    label = CollaborationStateUtils.getStateLabel(CollabState.Finished);
                    break;
                }
                return DropdownMenuItem(
                  value: state,
                  child: Row(
                    children: [
                      Icon(icon, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (state) {
                if (state != null) setState(() => _state = state);
              },
              onSaved: (state) {
                if (state != null) _state = state;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _goNext, child: Text(widget.confirmButtonLabel ?? 'Weiter')),
            ElevatedButton(onPressed: _goBack, child: Text(widget.cancelButtonLabel ?? 'Abbrechen')),
          ],
        ),
      ),
    );
  }
}
