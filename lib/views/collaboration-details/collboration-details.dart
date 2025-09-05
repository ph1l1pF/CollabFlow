import 'package:collabflow/models/collaboration.dart';
import 'package:collabflow/utils/collaboration-state-utils.dart';
import 'package:collabflow/views/collaboration-details/collaboration-details-view-model.dart';
import 'package:collabflow/views/create-collaboration/create-collaboration-page-2.dart';
import 'package:collabflow/views/create-collaboration/create-collaboration-page-3.dart';
import 'package:collabflow/views/create-collaboration/step-1-basic/create-collaboration-page-1.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                  child: ListTile(
                    title: Text(
                      viewModel.collab.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Bearbeiten',
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BasicCollaborationStep(
                              initialTitle: viewModel.collab.title,
                              initialDeadline: viewModel.collab.deadline,
                              initialFee: viewModel.collab.fee.amount,
                              initialState: viewModel.collab.state,
                              initialDescription: '',
                              confirmButtonLabel: 'Speichern',
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10), // Abstand erhöht
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18, color: Colors.blueGrey),
                            const SizedBox(width: 6),
                            Text(
                              "Deadline: ${DateFormat('dd.MM.yyyy').format(viewModel.collab.deadline.date)}",
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Abstand erhöht
                        Row(
                          children: [
                            const Icon(Icons.euro, color: Colors.black, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              "${NumberFormat("#,##0.00", "de_DE").format(viewModel.collab.fee.amount)} ${viewModel.collab.fee.currency}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Abstand erhöht
                        Row(
                          children: [
                            Text("Status: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade700)),
                            Icon(
                              CollaborationStateUtils.getStateIcon(viewModel.collab.state),
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              CollaborationStateUtils.getStateLabel(viewModel.collab.state),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                ExpansionTile(
                  leading: const Icon(Icons.description),
                  title: const Text("Skript & Notizen"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Bearbeiten',
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
                          Text("Notizen:\n${viewModel.collab.notes}"),
                          const SizedBox(height: 8),
                          if (viewModel.collab.script.content.isNotEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text("Script: ${viewModel.collab.script.content}"),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.fullscreen),
                                  tooltip: 'Skript im Vollbild',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => Scaffold(
                                          appBar: AppBar(
                                            title: const Text('Skript'),
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
                            ),
                          if (viewModel.collab.script.content.isEmpty)
                            const Text("Kein Skript vorhanden."),
                        ],
                      ),
                    ),
                  ],
                ),

                // Accordion: Partnerdaten
                ExpansionTile(
                  leading: const Icon(Icons.business),
                  title: const Text("Partner"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Bearbeiten',
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
                    ListTile(title: Text("Name: ${viewModel.collab.partner.name}")),
                    ListTile(
                      title: Text("Firma: ${viewModel.collab.partner.companyName}"),
                    ),
                    ListTile(
                      title: Text("Branche: ${viewModel.collab.partner.industry}"),
                    ),
                    ListTile(title: Text("Email: ${viewModel.collab.partner.email}")),
                    ListTile(
                      title: Text("Telefon: ${viewModel.collab.partner.phone}"),
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
              label: const Text('Collaboration löschen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Collaboration löschen?'),
                    content: const Text('Möchtest du diese Collaboration wirklich löschen?'),
                    actions: [
                      TextButton(
                        child: const Text('Abbrechen'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      TextButton(
                        child: const Text('Löschen'),
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
