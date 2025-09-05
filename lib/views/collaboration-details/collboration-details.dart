import 'package:collabflow/models/collaboration.dart';
import 'package:collabflow/utils/collaboration-state-utils.dart';
import 'package:collabflow/views/collaboration-details/collaboration-details-view-model.dart';
import 'package:collabflow/views/create-collaboration/create-collaboration-page-2.dart';
import 'package:collabflow/views/create-collaboration/create-collaboration-page-3.dart';
import 'package:collabflow/views/create-collaboration/step-1-basic/create-collaboration-page-1.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collabflow/l10n/app_localizations.dart';

class CollaborationDetailsPage extends StatefulWidget {
  final CollaborationDetailsViewModel viewModel;

  const CollaborationDetailsPage({super.key, required this.viewModel});

  @override
  State<CollaborationDetailsPage> createState() => _CollaborationDetailsPageState();
}

class _CollaborationDetailsPageState extends State<CollaborationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.collab.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // Kopfbereich – wichtigste Infos immer sichtbar
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.collab.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 18, color: Colors.blueGrey),
                                  const SizedBox(width: 6),
                                  Text(
                                    DateFormat.yMd(Localizations.localeOf(context).toString()).format(viewModel.collab.deadline.date),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.euro, color: Theme.of(context).colorScheme.onSurface, size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: 2).format(viewModel.collab.fee.amount),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.flag, size: 18, color: Colors.blueGrey),
                                  const SizedBox(width: 6),
                                  Icon(
                                    CollaborationStateUtils.getStateIcon(viewModel.collab.state),
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    CollaborationStateUtils.getStateLabel(viewModel.collab.state, context),
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: AppLocalizations.of(context)?.edit ?? 'Edit',
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BasicCollaborationStep(
                                  initialTitle: viewModel.collab.title,
                                  initialDeadline: viewModel.collab.deadline,
                                  initialFee: viewModel.collab.fee.amount,
                                  initialState: viewModel.collab.state,
                                  initialDescription: '',
                                  confirmButtonLabel: AppLocalizations.of(context)?.save ?? 'Save',
                                  onNext: ({
                                    required bool next,
                                    required String title,
                                    required String description,
                                    required Deadline deadline,
                                    required double fee,
                                    required CollabState state,
                                  }) {
                                    _handleBasicInfo(
                                      next: next,
                                      context: context,
                                      title: title,
                                      description: description,
                                      deadline: deadline,
                                      fee: fee,
                                      state: state,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                ExpansionTile(
                  leading: const Icon(Icons.description),
                  title: Text(AppLocalizations.of(context)?.scriptAndNotes ?? "Script & Notes"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: AppLocalizations.of(context)?.edit ?? 'Edit',
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ScriptStep(
                                initialNotes: viewModel.collab.notes,
                                initialScriptContent: viewModel.collab.script.content,
                                onNext: ({
                                  required String scriptContent,
                                  required String notes,
                                  required bool next,
                                }) {
                                  _handleScriptStep(
                                    context: context,
                                    scriptContent: scriptContent,
                                    notes: notes,
                                    next: next,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const Icon(Icons.expand_more), // Chevron
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)?.notes ?? "Notes", style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text(
                            viewModel.collab.notes.isEmpty ? (AppLocalizations.of(context)?.noNotes ?? "No notes.") : viewModel.collab.notes,
                          ),
                          const Divider(height: 20),
                          Text(AppLocalizations.of(context)?.script ?? "Script", style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          if (viewModel.collab.script.content.isNotEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(viewModel.collab.script.content),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.fullscreen),
                                  tooltip: AppLocalizations.of(context)?.fullscreen ?? 'Script in fullscreen',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => Scaffold(
                                          appBar: AppBar(
                                            title: Text(AppLocalizations.of(context)?.script ?? 'Script'),
                                          ),
                                          body: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: SingleChildScrollView(
                                              child: Text(
                                                viewModel.collab.script.content,
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          else
                            Text(AppLocalizations.of(context)?.noScript ?? "No script available."),
                        ],
                      ),
                    ),
                  ],
                ),

                // Accordion: Partnerdaten
                ExpansionTile(
                  leading: const Icon(Icons.business),
                  title: Text(AppLocalizations.of(context)?.partner ?? "Partner"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: AppLocalizations.of(context)?.edit ?? 'Edit',
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PartnerStep(
                                initialCompanyName: viewModel.collab.partner.companyName,
                                initialEmail: viewModel.collab.partner.email,
                                initialIndustry: viewModel.collab.partner.industry,
                                initialName: viewModel.collab.partner.name,
                                initialPhone: viewModel.collab.partner.phone,
                                initialCustomerNumber: viewModel.collab.partner.customerNumber,
                                onFinish: (partner, next) {
                                  _handlePartnerStep(context, partner, next);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const Icon(Icons.expand_more), // Chevron
                    ],
                  ),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(viewModel.collab.partner.name),
                      subtitle: Text(AppLocalizations.of(context)?.name ?? "Name"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.apartment),
                      title: Text(viewModel.collab.partner.companyName),
                      subtitle: Text(AppLocalizations.of(context)?.company ?? "Company"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.category_outlined),
                      title: Text(viewModel.collab.partner.industry),
                      subtitle: Text(AppLocalizations.of(context)?.industry ?? "Industry"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: Text(viewModel.collab.partner.email),
                      subtitle: Text(AppLocalizations.of(context)?.email ?? "Email"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone_outlined),
                      title: Text(viewModel.collab.partner.phone),
                      subtitle: Text(AppLocalizations.of(context)?.phone ?? "Phone"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: Text(AppLocalizations.of(context)?.deleteCollaboration ?? 'Delete Collaboration'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(AppLocalizations.of(context)?.deleteCollaboration ?? 'Delete Collaboration'),
                    content: Text(AppLocalizations.of(context)?.deleteCollaborationConfirm ?? 'Do you really want to delete this collaboration?'),
                    actions: [
                      TextButton(
                        child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      TextButton(
                        child: Text(AppLocalizations.of(context)?.delete ?? 'Delete'),
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  viewModel.deleteCollaboration();
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleBasicInfo({
    required bool next,
    required BuildContext context,
    required String title,
    required String description,
    required Deadline deadline,
    required double fee,
    required CollabState state,
  }) {
    if(next){
      setState(() {
        widget.viewModel.collab.title = title;
        widget.viewModel.collab.deadline = deadline;
        widget.viewModel.collab.fee = Fee(amount: fee, currency: 'EUR');
        widget.viewModel.collab.state = state;
        widget.viewModel.updateCollaboration(widget.viewModel.collab);
      });
    }
    Navigator.of(context).pop();
  }

  void _handleScriptStep({
    required BuildContext context,
    required String scriptContent,
    required String notes,
    required bool next,
  }) {
    if(next){
      setState(() {
        widget.viewModel.collab.script.content = scriptContent;
        widget.viewModel.collab.notes = notes;
        widget.viewModel.updateCollaboration(widget.viewModel.collab);
      });
    }
    Navigator.of(context).pop();
  }

  void _handlePartnerStep(BuildContext context, Partner partner, bool next) {
    if(next){
      setState(() {
        widget.viewModel.collab.partner = partner;
        widget.viewModel.updateCollaboration(widget.viewModel.collab);
      });
    }
    Navigator.of(context).pop();
  }
}
