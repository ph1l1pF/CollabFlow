import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BasicCollaborationStep extends StatefulWidget {
  final void Function({
    required String title,
    required String description,
    required DateTime deadline,
  })
  onNext;

  const BasicCollaborationStep({super.key, required this.onNext});

  @override
  State<BasicCollaborationStep> createState() => _BasicCollaborationStepState();
}

class _BasicCollaborationStepState extends State<BasicCollaborationStep> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _deadline = DateTime.now();

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
        title: _title,
        description: _description,
        deadline: _deadline,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Titel der Kooperation',
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? 'Titel eingeben' : null,
              onSaved: (val) => _title = val ?? '',
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Beschreibung'),
              maxLines: 3,
              onSaved: (val) => _description = val ?? '',
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text("Deadline"),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_deadline)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDeadline,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _goNext, child: const Text("Weiter")),
          ],
        ),
      ),
    );
  }
}
