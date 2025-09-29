import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ugcworks/constants/app_colors.dart';
import 'package:ugcworks/l10n/app_localizations.dart';
import 'package:ugcworks/models/collaboration.dart';
import 'package:ugcworks/repositories/collaborations-repository.dart';
import 'package:ugcworks/repositories/shared-prefs-repository.dart';
import 'package:ugcworks/utils/collaboration-state-utils.dart';
import 'package:ugcworks/utils/theme_utils.dart';
import 'package:ugcworks/views/collaboration-details/collboration-details.dart';
import 'package:ugcworks/views/collaboration-details/collaboration-details-view-model.dart';
import 'package:ugcworks/views/collaborations-list/collaboration-list-view-model.dart';
import 'package:ugcworks/views/create-collaboration/create-collaboration.dart';
import 'package:ugcworks/widgets/notification_bell.dart';

class CollaborationListPage extends StatefulWidget {
  const CollaborationListPage({super.key});

  @override
  State<CollaborationListPage> createState() => _CollaborationListPageState();
}

class _CollaborationListPageState extends State<CollaborationListPage> {
  String _searchText = '';
  List<CollabState> _selectedStates = [];

  @override
  void initState() {
    super.initState();
    _loadSelectedStates();
  }

  Future<void> _loadSelectedStates() async {
    final prefs = Provider.of<SharedPrefsRepository>(context, listen: false);
    final savedStates = await prefs.loadSelectedStates();
    setState(() {
      _selectedStates = savedStates.map((s) => CollabState.values[int.parse(s)]).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ThemeUtils.getBackgroundDecoration(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            AppLocalizations.of(context)?.collaborations ?? "Collaborations",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          actions: [
            // Search button
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)?.search ?? "Search"),
                      content: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchText = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search collaborations...",
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.search),
            ),
            // Filter button
            IconButton(
              onPressed: () async {
                final result = await showDialog<List<CollabState>>(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)?.filterByStatus ?? "Filter by Status"),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: CollabState.values.map((state) {
                                final isSelected = _selectedStates.contains(state);
                                return CheckboxListTile(
                                  title: Text(
                                    CollaborationStateUtils.getStateLabel(state, context),
                                  ),
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        _selectedStates.add(state);
                                      } else {
                                        _selectedStates.remove(state);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(AppLocalizations.of(context)?.cancel ?? "Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(_selectedStates);
                              },
                              child: Text(AppLocalizations.of(context)?.apply ?? "Apply"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
                if (!mounted) return;
                if (result != null) {
                  setState(() {
                    _selectedStates = result;
                  });
                  // persist
                  final prefs = Provider.of<SharedPrefsRepository>(
                    context,
                    listen: false,
                  );
                  await prefs.saveSelectedStates(
                    _selectedStates.map((e) => e.index.toString()).toList(),
                  );
                }
              },
              icon: const Icon(Icons.filter_list),
            ),
          ],
        ),
        body: Consumer<CollaborationsListViewModel>(
          builder: (context, viewModel, _) {
            final matchesSearch = viewModel.collaborations
                .where(
                  (c) => c.title.toLowerCase().trim().contains(
                    _searchText.toLowerCase().trim(),
                  ),
                )
                .toList();
            final filtered =
                (_selectedStates.isEmpty
                      ? matchesSearch
                      : matchesSearch
                            .where((c) => _selectedStates.contains(c.state))
                            .toList())
                  ..sort((a, b) => a.deadline.compareTo(b.deadline));

            return filtered.isEmpty
                ? viewModel.collaborations.isEmpty
                      ? Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CollaborationWizard(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: Text(
                              AppLocalizations.of(context)?.createCollaboration ??
                                  "Create Collaboration",
                            ),
                            style: AppColors.primaryButtonStyle,
                          ),
                        )
                      : Center(
                          child: Text(
                            AppLocalizations.of(context)?.noCollaborationsFound ??
                                "No collaborations found",
                          ),
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
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(AppLocalizations.of(context)?.deleteCollaboration ?? "Delete Collaboration"),
                                content: Text("Are you sure you want to delete this collaboration?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text(AppLocalizations.of(context)?.cancel ?? "Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text(AppLocalizations.of(context)?.delete ?? "Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          final repository = Provider.of<CollaborationsRepository>(
                            context,
                            listen: false,
                          );
                          repository.deleteById(collab.id);
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
                                // Deadline with notification bell
                                Row(
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)?.deadline ?? "Deadline"}: ${DateFormat.yMd(Localizations.localeOf(context).toString()).format(collab.deadline)}",
                                    ),
                                    const SizedBox(width: 8),
                                    NotificationBell(
                                      hasNotifications: collab.hasNotifications,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                if (collab.partner != "")
                                  Text(
                                    "${AppLocalizations.of(context)?.brand ?? "Brand"}: ${collab.partner}",
                                  ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)?.status ?? "Status"}: ",
                                    ),
                                    Icon(
                                      collab.stateIcon,
                                      color: AppColors.primaryPink,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      CollaborationStateUtils.getStateLabel(
                                        collab.state,
                                        context,
                                      ),
                                    ),
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
      ),
    );
  }
}
