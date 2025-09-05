import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collabflow/services/collaboration-export-service.dart';
import 'package:collabflow/views/earnings-overview/earnings-overview-view-model.dart';

class EarningsOverviewPage extends StatefulWidget {
  const EarningsOverviewPage({super.key});

  @override
  State<EarningsOverviewPage> createState() => _EarningsOverviewPageState();
}

class _EarningsOverviewPageState extends State<EarningsOverviewPage> {
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedRange = DateTimeRange(
      start: DateTime(now.year, 1, 1),
      end: DateTime(now.year, 12, 31, 23, 59, 59, 999),
    );
  }

  Future<void> _openDateRangePicker() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _selectedRange ??
          DateTimeRange(start: DateTime(now.year, 1, 1), end: now),
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() => _selectedRange = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EarningsOverviewViewModel>(
      builder: (context, viewModel, _) {
        final entries = viewModel.entries;
        final filtered = entries.where((e) {
          if (_selectedRange == null) return true;
          return e.date.isAfter(_selectedRange!.start) &&
                 e.date.isBefore(_selectedRange!.end);
        }).toList();

        final total = filtered.fold<double>(0, (sum, e) => sum + e.amount);
        final locale = Localizations.localeOf(context).toString();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Einnahmen-Übersicht"),
            actions: [
              IconButton(
                icon: const Icon(Icons.download),
                tooltip: 'Exportieren',
                onPressed: () async {
                  final csvService = Provider.of<CollaborationExportService>(context, listen: false);
                  final choice = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text('Exportformat wählen'),
                        children: [
                          ListTile(
                            leading: const Icon(Icons.table_chart),
                            title: const Text('CSV'),
                            onTap: () => Navigator.pop(context, 'csv'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.picture_as_pdf),
                            title: const Text('PDF'),
                            onTap: () => Navigator.pop(context, 'pdf'),
                          ),
                          const Divider(height: 0),
                          ListTile(
                            leading: const Icon(Icons.close),
                            title: const Text('Abbrechen'),
                            onTap: () => Navigator.pop(context, null),
                          ),
                        ],
                      );
                    },
                  );
                  if (choice == 'csv') {
                    await csvService.exportEarningsEntries(entries);
                  } else if (choice == 'pdf') {
                    await csvService.exportEarningsEntriesPdf(filtered);
                  }
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _openDateRangePicker,
                      child: const Icon(Icons.date_range, size: 20),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _openDateRangePicker,
                      child: Text(
                        _selectedRange == null
                            ? "Alle Zeiträume"
                            : "${DateFormat('dd.MM.yyyy').format(_selectedRange!.start)} – ${DateFormat('dd.MM.yyyy').format(_selectedRange!.end)}",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              if (entries.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      "Es gibt noch keine Collaborations.\nErstelle deine erste Collaboration.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else ...[
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Datum")),
                        DataColumn(label: Text("Titel")),
                        DataColumn(label: Text("Betrag")),
                      ],
                      rows: filtered.map((e) {
                        return DataRow(cells: [
                          DataCell(Text(DateFormat("dd.MM.yyyy").format(e.date))),
                          DataCell(Text(
                            e.title.substring(0, e.title.length > 12 ? 12 : e.title.length) +
                                (e.title.length > 12 ? "..." : ""),
                          )),
                          DataCell(Text(
                            NumberFormat.currency(locale: locale, symbol: "€").format(e.amount),
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
                              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Summe: ${NumberFormat.currency(locale: locale, symbol: "€").format(total)}",
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      "Anzahl: ${filtered.length}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              ],
            ],
          ),
        );
      },
    );
  }
}
