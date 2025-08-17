import 'package:collabflow/models/collaboration.dart';
import 'package:collabflow/repositories/collaborations-repository.dart';
import 'package:collabflow/views/collaboration-details/collaboration-details-view-model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CollaborationDetailsPage extends StatelessWidget {
  late CollaborationDetailsViewModel viewModel;

  CollaborationDetailsPage({super.key, required this.viewModel}) {
    
  }
  @override
  Widget build(BuildContext context) {
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
                  content: const Text('Möchtest du diese Kollaboration wirklich löschen?'),
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Deadline: ${DateFormat('dd.MM.yyyy').format(viewModel.collab.deadline)}"),
                  Text("Partner: ${viewModel.collab.partner.name}"),
                ],
              ),
            ),
          ),

          // Accordion: Beschreibung & Anforderungen
          ExpansionTile(
            leading: const Icon(Icons.description),
            title: const Text("Beschreibung & Anforderungen"),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (viewModel.collab.requirements.requirements.isNotEmpty)
                      Text(
                        "Anforderungen:\n${viewModel.collab.requirements.requirements.join("\n")}",
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
            children: [
              ListTile(title: Text("Name: ${viewModel.collab.partner.name}")),
              ListTile(title: Text("Firma: ${viewModel.collab.partner.companyName}")),
              ListTile(title: Text("Branche: ${viewModel.collab.partner.industry}")),
              ListTile(title: Text("Email: ${viewModel.collab.partner.email}")),
              ListTile(title: Text("Telefon: ${viewModel.collab.partner.phone}")),
            ],
          ),

          // Accordion: Konditionen
          ExpansionTile(
            leading: const Icon(Icons.euro),
            title: const Text("Konditionen"),
            children: [
              ListTile(
                title: Text("Honorar: ${viewModel.collab.fee.amount} ${viewModel.collab.fee.currency}"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
