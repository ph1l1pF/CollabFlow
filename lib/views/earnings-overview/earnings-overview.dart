import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ugcworks/services/collaboration-export-service.dart';
import 'package:ugcworks/views/earnings-overview/earnings-overview-view-model.dart';
import 'package:ugcworks/l10n/app_localizations.dart';

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
      initialDateRange:
          _selectedRange ??
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
            title: Text(
              AppLocalizations.of(context)?.earningsOverview ??
                  "Earnings Overview",
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.download),
                tooltip: AppLocalizations.of(context)?.export ?? 'Export',
                onPressed: () async {
                  final csvService = Provider.of<CollaborationExportService>(
                    context,
                    listen: false,
                  );
                  final l10n = AppLocalizations.of(context);
                  final choice = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text(
                          l10n?.exportFormat ?? 'Choose export format',
                        ),
                        children: [
                          ListTile(
                            leading: const Icon(Icons.table_chart),
                            title: Text(l10n?.csv ?? 'CSV'),
                            onTap: () => Navigator.pop(context, 'csv'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.picture_as_pdf),
                            title: Text(l10n?.pdf ?? 'PDF'),
                            onTap: () => Navigator.pop(context, 'pdf'),
                          ),
                          const Divider(height: 0),
                          ListTile(
                            leading: const Icon(Icons.close),
                            title: Text(l10n?.cancel ?? 'Cancel'),
                            onTap: () => Navigator.pop(context, null),
                          ),
                        ],
                      );
                    },
                  );
                  if (choice == 'csv') {
                    await csvService.exportEarningsEntries(
                      entries,
                      locale: locale,
                      dateHeader: l10n?.date ?? 'Date',
                      titleHeader: l10n?.titleForTable ?? 'Title',
                      amountHeader: l10n?.amount ?? 'Amount',
                      shareText: l10n?.earningsAsCsv ?? 'Earnings as CSV',
                    );
                  } else if (choice == 'pdf') {
                    await csvService.exportEarningsEntriesPdf(
                      filtered,
                      locale: locale,
                      dateHeader: l10n?.date ?? 'Date',
                      titleHeader: l10n?.titleForTable ?? 'Title',
                      amountHeader: l10n?.amount ?? 'Amount',
                      earningsTitle:
                          l10n?.earningsOverview ?? 'Earnings Overview',
                      sumLabel: l10n?.sum ?? 'Sum',
                      shareText: l10n?.earningsAsPdf ?? 'Earnings as PDF',
                    );
                  }
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _openDateRangePicker,
                      child: const Icon(Icons.date_range, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _openDateRangePicker,
                        child: Text(
                          _selectedRange == null
                              ? (AppLocalizations.of(context)?.allTimeframes ??
                                    "All timeframes")
                              : "${DateFormat.yMd(Localizations.localeOf(context).toString()).format(_selectedRange!.start)} – ${DateFormat.yMd(Localizations.localeOf(context).toString()).format(_selectedRange!.end)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (entries.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)?.noCollaborationsYet ??
                          "There are no collaborations yet.\nCreate your first collaboration.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else ...[
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(context)?.deadline ??
                                "Deadline",
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(context)?.titleForTable ??
                                "Title",
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(context)?.feeForTable ??
                                "Amount",
                          ),
                        ),
                      ],
                      rows: filtered.map((e) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                DateFormat.yMd(
                                  Localizations.localeOf(context).toString(),
                                ).format(e.date),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.title.substring(
                                      0,
                                      e.title.length > 12 ? 12 : e.title.length,
                                    ) +
                                    (e.title.length > 12 ? "..." : ""),
                              ),
                            ),
                            DataCell(
                              Text(
                                NumberFormat.currency(
                                  locale: locale,
                                  symbol: "€",
                                ).format(e.amount),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)?.sum ?? "Sum"}: ${NumberFormat.currency(locale: locale, symbol: "€").format(total)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "${AppLocalizations.of(context)?.count ?? "Count"}: ${filtered.length}",
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
