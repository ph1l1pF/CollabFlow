import 'package:flutter/material.dart';
import 'package:ugcworks/utils/theme_utils.dart';

class ScriptStep extends StatefulWidget {
  final void Function({
    required String scriptContent,
    required String notes,
    required bool next,
  }) onNext;
  final String initialScriptContent;
  final String initialNotes;

  const ScriptStep({
    super.key,
    required this.onNext,
    required this.initialScriptContent,
    required this.initialNotes,
  });

  @override
  State<ScriptStep> createState() => _ScriptStepState();
}

class _ScriptStepState extends State<ScriptStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _scriptController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _scriptController = TextEditingController(text: widget.initialScriptContent);
    _notesController = TextEditingController(text: widget.initialNotes);
  }

  @override
  void dispose() {
    _scriptController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onNext(
        scriptContent: _scriptController.text,
        notes: _notesController.text,
        next: true,
      );
    }
  }

  void _goBack() {
    widget.onNext(
      scriptContent: _scriptController.text,
      notes: _notesController.text,
      next: false,
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
          title: const Text('Skript & Notizen bearbeiten'),
          elevation: 0,
        ),
        body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _scriptController,
              decoration: const InputDecoration(labelText: 'Script (optional)'),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notizen (optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: _goBack, child: const Text('Zurück')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _goNext, child: const Text('Weiter')),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}
