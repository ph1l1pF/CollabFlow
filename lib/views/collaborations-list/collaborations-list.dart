import 'package:collabflow/repositories/collaborations-repository.dart';
import 'package:collabflow/views/collaboration-details/collaboration-details-view-model.dart';
import 'package:collabflow/views/collaboration-details/collboration-details.dart';
import 'package:collabflow/views/collaborations-list/collaboration-list-view-model.dart';
import 'package:collabflow/views/create-collaboration/create-collaboration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collabflow/models/collaboration.dart';
import 'package:collabflow/utils/collaboration-state-utils.dart';
import 'package:collabflow/repositories/shared-prefs-repository.dart';

class CollaborationListPage extends StatefulWidget {
  const CollaborationListPage({super.key});

  @override
  State<CollaborationListPage> createState() => _CollaborationListPageState();
}

class _CollaborationListPageState extends State<CollaborationListPage> {
  String _searchText = "";
  bool _showSearch = false;
  Set<CollabState> _selectedStates = {};
  bool _loadingPrefs = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedStates();
  }

  Future<void> _loadSelectedStates() async {
    final prefs = Provider.of<SharedPrefsRepository>(context, listen: false);
    final stored = await prefs.loadSelectedStates();
    final selected = stored
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .where((i) => i >= 0 && i < CollabState.values.length)
        .map((i) => CollabState.values[i])
        .toSet();
    if (!mounted) return;
    setState(() {
      _selectedStates = selected;
      _loadingPrefs = false;
    });
  }

  Widget build(BuildContext context) {
    if (_loadingPrefs) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
            : const Text("Meine Collaborations"),
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
          Consumer<CollaborationsListViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.collaborations.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(_selectedStates.isEmpty ? Icons.filter_alt_outlined : Icons.filter_alt),
                tooltip: 'Status filtern',
                onPressed: () async {
                  final states = CollabState.values;
                  final tempSelected = Set<CollabState>.from(_selectedStates);
                  final result = await showDialog<Set<CollabState>>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Nach Status filtern'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              
                              const SizedBox(height: 8),
                              for (final s in states)
                                CheckboxListTile(
                                  value: tempSelected.contains(s),
                                  title: Text(CollaborationStateUtils.getStateLabel(s)),
                                  secondary: Icon(CollaborationStateUtils.getStateIcon(s)),
                                  onChanged: (checked) {
                                    if (checked == true) {
                                      tempSelected.add(s);
                                    } else {
                                      tempSelected.remove(s);
                                    }
                                    (context as Element).markNeedsBuild();
                                  },
                                ),
                                Row(
                                children: [
                                  Expanded(
                                    child: TextButton.icon(
                                      onPressed: () {
                                        tempSelected.clear();
                                        (context as Element).markNeedsBuild();
                                      },
                                      icon: const Icon(Icons.filter_alt_off),
                                      label: const Text('Filter entfernen'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextButton.icon(
                                      onPressed: () {
                                        tempSelected
                                          ..clear()
                                          ..addAll(states);
                                        (context as Element).markNeedsBuild();
                                      },
                                      icon: const Icon(Icons.select_all),
                                      label: const Text('Alle auswählen'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton.icon(
                            onPressed: () => Navigator.pop(context, tempSelected),
                            icon: const Icon(Icons.check),
                            label: const Text('Übernehmen'),
                          ),
                          TextButton.icon(
                            onPressed: () => Navigator.pop(context, _selectedStates),
                            icon: const Icon(Icons.close),
                            label: const Text('Abbrechen'),
                          ),
                        ],
                      );
                    },
                  );
                  if (!mounted) return;
                  if (result != null) {
                    setState(() {
                      _selectedStates = result;
                    });
                    // persist
                    final prefs = Provider.of<SharedPrefsRepository>(context, listen: false);
                    await prefs.saveSelectedStates(
                      _selectedStates.map((e) => e.index.toString()).toList(),
                    );
                  }
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
          final matchesSearch = viewModel.collaborations
              .where((c) => c.title.toLowerCase().trim().contains(_searchText.toLowerCase().trim()))
              .toList();
          final filtered = (_selectedStates.isEmpty
                  ? matchesSearch
                  : matchesSearch.where((c) => _selectedStates.contains(c.state)).toList())
              ..sort((a, b) => a.deadline.compareTo(b.deadline));

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
                  child: Text("Keine Collaborations gefunden"),
                )
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final collab = filtered[index];
                    return Dismissible(
                      key: Key(collab.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
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
                      },
                      onDismissed: (direction) {
                        Provider.of<CollaborationsRepository>(context, listen: false)
                            .deleteById(collab.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Collaboration gelöscht')),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
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
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(collab.stateIcon, color: Colors.blue, size: 16),
                                  const SizedBox(width: 6),
                                  Text(CollaborationStateUtils.getStateLabel(collab.state)),
                                ],
                              ),
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
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
