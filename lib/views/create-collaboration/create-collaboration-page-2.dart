import 'package:flutter/material.dart';
import 'package:ugcworks/utils/theme_utils.dart';
import 'package:ugcworks/constants/app_colors.dart';
import 'package:ugcworks/l10n/app_localizations.dart';

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
          title: Text(AppLocalizations.of(context)?.editScriptAndNotes ?? 'Edit Script & Notes'),
          elevation: 0,
        ),
        body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _scriptController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)?.scriptOptional ?? 'Script (optional)'),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)?.notesOptional ?? 'Notes (optional)'),
              maxLines: 3,
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
                        Icon(Icons.arrow_back, size: 20),
                        SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)?.back ?? 'Back',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _goNext,
                    style: AppColors.primaryButtonStyle.copyWith(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.next ?? 'Next',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
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
