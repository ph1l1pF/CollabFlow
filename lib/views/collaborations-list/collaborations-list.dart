import 'package:collabflow/repositories/collaborations-repository.dart';
import 'package:collabflow/views/collaboration-details/collaboration-details-view-model.dart';
import 'package:collabflow/views/collaboration-details/collboration-details.dart';
import 'package:collabflow/views/collaborations-list/view-models/collaboration-list.dart';
import 'package:collabflow/views/create-collaboration/create-collaboration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CollaborationListPage extends StatefulWidget {
  const CollaborationListPage({super.key});

  @override
  State<CollaborationListPage> createState() => _CollaborationListPageState();
}

class _CollaborationListPageState extends State<CollaborationListPage> {
  String _searchText = "";
  bool _showSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Suchen...",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchText = val;
                  });
                },
              )
            : const Text("Meine Kollaborationen"),
        actions: [
          Consumer<CollaborationsListViewModel>(
            builder: (context, viewModel, _) {
              // Nur anzeigen, wenn Collaborations vorhanden sind
              if (viewModel.collaborations.isEmpty) return const SizedBox.shrink();
              return !_showSearch
                  ? IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _showSearch = true;
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _showSearch = false;
                          _searchText = "";
                        });
                      },
                    );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CollaborationWizard()),
              );
            },
          ),
        ],
      ),
      body: Consumer<CollaborationsListViewModel>(
        builder: (context, viewModel, _) {
          final filtered = viewModel.collaborations
              .where((c) => c.title.toLowerCase().trim().contains(_searchText.toLowerCase().trim()))
              .toList();

          return filtered.isEmpty
              ? 
              viewModel.collaborations.isEmpty ?
              Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CollaborationWizard(),
                        ),
                      );
                    },
                    child: const Text("Collaboration erstellen"),
                  ),
                )
                : const Center(
                  child: Text("Keine Kollaborationen gefunden"),
                )
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final collab = filtered[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
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
                                  collaborationsRepository:
                                      Provider.of<CollaborationsRepository>(
                                        context,
                                        listen: false,
                                      ),
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
