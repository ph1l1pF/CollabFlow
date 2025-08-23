import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BasicCollaborationStep extends StatefulWidget {
  final void Function({
    required String title,
    required String description,
    required DateTime deadline,
    required double fee,
    required bool next,
  })
  onNext;
  final String initialTitle;
  final String initialDescription;
  final DateTime initialDeadline;
  final double initialFee;
  String? confirmButtonLabel;
  String? cancelButtonLabel;

  BasicCollaborationStep({
    super.key,
    required this.onNext,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialDeadline,
    required this.initialFee,
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

  @override
  void initState() {
    super.initState();
    _title = widget.initialTitle;
    _description = widget.initialDescription;
    _deadline = widget.initialDeadline;
    _fee = widget.initialFee;
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
        fee: _fee
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
      fee: _fee
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
                labelText: 'Honorar',
                prefixText: '€ ',
              ),
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Honorar eingeben';
                final fee = double.tryParse(val.replaceAll(',', '.'));
                if (fee == null || fee < 0) return 'Gültigen Betrag eingeben';
                return null;
              },
              onSaved: (val) => _fee = double.tryParse(val!.replaceAll(',', '.')) ?? 0,
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
