import 'package:flutter/material.dart';

class ScriptStep extends StatefulWidget {
  final void Function({required String scriptContent, required String notes})
  onNext;

  const ScriptStep({super.key, required this.onNext});

  @override
  State<ScriptStep> createState() => _ScriptStepState();
}

class _ScriptStepState extends State<ScriptStep> {
  final _formKey = GlobalKey<FormState>();
  String _scriptContent = '';
  String _notes = '';

  void _goNext() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.onNext(scriptContent: _scriptContent, notes: _notes);
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
                labelText: 'Skript',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
              onSaved: (val) => _scriptContent = val ?? '',
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Notizen (optional)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              onSaved: (val) => _notes = val ?? '',
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _goNext, child: const Text("Weiter")),
          ],
        ),
      ),
    );
  }
}
