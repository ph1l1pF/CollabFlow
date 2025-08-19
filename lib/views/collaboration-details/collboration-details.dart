import 'package:collabflow/models/collaboration.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Löschen',
            onPressed: () async {
              // Löschen bestätigen
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Kollaboration löschen?'),
                  content: const Text(
                    'Möchtest du diese Kollaboration wirklich löschen?',
                  ),
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
        ],
      ),
      body: ListView(
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
                        initialDescription: '',
                        buttonLabel: 'Speichern',
                        onNext: ({
                          required String title,
                          required String description,
                          required DateTime deadline,
                        }) {
                          _handleBasicInfo(
                            context: context,
                            title: title,
                            description: description,
                            deadline: deadline,
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
                  Text(
                    "Deadline: ${DateFormat('dd.MM.yyyy').format(viewModel.collab.deadline)}",
                  ),
                  Text("Partner: ${viewModel.collab.partner.name}"),
                ],
              ),
            ),
          ),

          // Accordion: Beschreibung & Anforderungen
          ExpansionTile(
            leading: const Icon(Icons.description),
            title: const Text("Beschreibung & Anforderungen"),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Bearbeiten',
              onPressed: () async {
                // Beispiel: Editier-Dialog öffnen
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
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Text(
                      "Notizen:\n${viewModel.collab.notes}",
                    ),
                    const SizedBox(height: 8),
                    if (viewModel.collab.script.content.isNotEmpty)
                      Text("Script: ${viewModel.collab.script.content}"),
                  ],
                ),
              ),
            ],
          ),

          // Accordion: Partnerdaten
          ExpansionTile(
            leading: const Icon(Icons.business),
            title: const Text("Partner"),
            trailing: IconButton(
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

          // Accordion: Konditionen
          ExpansionTile(
            leading: const Icon(Icons.euro),
            title: const Text("Konditionen"),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Bearbeiten',
              onPressed: () async {
                // await Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => EditFeePage(
                //       initialFee: viewModel.collab.fee,
                //       onSave: (fee) {
                //         viewModel.collab.fee = fee;
                //         Navigator.of(context).pop();
                //       },
                //     ),
                //   ),
                // );
              },
            ),
            children: [
              ListTile(
                title: Text(
                  "Honorar: ${viewModel.collab.fee.amount} ${viewModel.collab.fee.currency}",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleBasicInfo({
    required BuildContext context,
    required String title,
    required String description,
    required DateTime deadline,
  }) {
    setState(() {
      widget.viewModel.collab.title = title;
      widget.viewModel.collab.deadline = deadline;
      widget.viewModel.updateCollaboration(widget.viewModel.collab);
    });
    Navigator.of(context).pop();
  }

  void _handleScriptStep({
    required BuildContext context,
    required String scriptContent,
    required String notes,
    required bool next,
  }) {
    setState(() {
      widget.viewModel.collab.script.content = scriptContent;
      widget.viewModel.collab.notes = notes;
      widget.viewModel.updateCollaboration(widget.viewModel.collab);
    });
    Navigator.of(context).pop();
  }

  void _handlePartnerStep(BuildContext context, Partner partner, bool next) {
    setState(() {
      widget.viewModel.collab.partner = partner;
      widget.viewModel.updateCollaboration(widget.viewModel.collab);
    });
    Navigator.of(context).pop();
  }
}
