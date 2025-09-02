import 'package:collabflow/repositories/collaborations-repository.dart';
import 'package:collabflow/views/collaboration-details/collaboration-details-view-model.dart';
import 'package:collabflow/views/collaboration-details/collboration-details.dart';
import 'package:collabflow/views/collaborations-list/view-models/collaboration-list.dart';
import 'package:collabflow/views/create-collaboration/create-collaboration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CollaborationListPage extends StatelessWidget {

  const CollaborationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meine Kollaborationen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CollaborationWizard(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CollaborationsListViewModel>(
        builder: (context, viewModel, _) {
          return viewModel.collaborations.isEmpty
              ? Center(
                  child: Text(
                    "Noch keine Kollaborationen vorhanden.\nErstelle deine erste mit '+'",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: viewModel.collaborations.length,
                  itemBuilder: (context, index) {
                    final collab = viewModel.collaborations[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(collab.stateIcon, color: Colors.blue),
                        title: Text(
                          collab.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              "Deadline: ${DateFormat('dd.MM.yyyy').format(collab.deadline)}",
                            ),
                            Text("Brand: ${collab.partner}"),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CollaborationDetailsPage(
                                viewModel: CollaborationDetailsViewModel(
                                  collaborationsRepository: Provider.of<CollaborationsRepository>(context, listen: false),
                                  collabId: collab.id,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
