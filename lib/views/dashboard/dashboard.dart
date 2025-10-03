import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ugcworks/views/dashboard/dashboard-view-model.dart';
import 'package:ugcworks/views/create-collaboration/create-collaboration.dart';
import 'package:ugcworks/l10n/app_localizations.dart';
import 'package:ugcworks/constants/app_colors.dart';
import 'package:ugcworks/utils/theme_utils.dart';
import 'package:ugcworks/utils/currency_utils.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ThemeUtils.getBackgroundDecoration(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            AppLocalizations.of(context)?.dashboard ?? "Dashboard",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Consumer<DashboardViewModel>(
          builder: (context, viewModel, _) {
            if (!viewModel.hasCollaborations) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20), // Standard bottom padding
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome message
                    Text(
                      AppLocalizations.of(context)?.dashboardWelcome ?? "Welcome back! 👋",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)?.dashboardSubtitle ?? "Here's your collaboration overview",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Metrics tiles
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.8,
                      children: [
                        _buildMetricTile(
                          context: context,
                          title: AppLocalizations.of(context)?.totalEarnings ?? "Total Earnings",
                          value: NumberFormat.currency(
                            locale: Localizations.localeOf(context).toString(),
                            symbol: CurrencyUtils.getCurrencySymbol(),
                          ).format(viewModel.totalEarnings),
                          icon: CurrencyUtils.getCurrencyIcon(),
                          color: Colors.green,
                          subtitle: AppLocalizations.of(context)?.allTime ?? "All time",
                        ),
                        _buildMetricTile(
                          context: context,
                          title: AppLocalizations.of(context)?.totalCollaborations ?? "Total Collaborations",
                          value: viewModel.totalCollaborations.toString(),
                          icon: Icons.handshake,
                          color: AppColors.primaryPink,
                          subtitle: AppLocalizations.of(context)?.allTime ?? "All time",
                        ),
                        _buildMetricTile(
                          context: context,
                          title: AppLocalizations.of(context)?.activeCollaborations ?? "Active",
                          value: viewModel.activeCollaborations.toString(),
                          icon: Icons.trending_up,
                          color: Colors.blue,
                          subtitle: AppLocalizations.of(context)?.inProgress ?? "In progress",
                        ),
                        _buildMetricTile(
                          context: context,
                          title: AppLocalizations.of(context)?.completedCollaborations ?? "Completed",
                          value: viewModel.completedCollaborations.toString(),
                          icon: Icons.check_circle,
                          color: Colors.orange,
                          subtitle: AppLocalizations.of(context)?.finished ?? "Finished",
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Highest paid collaboration tile
                    if (viewModel.highestPaidCollaboration != null) ...[
                      Text(
                        AppLocalizations.of(context)?.highestPaidCollab ?? "Highest Paid Collaboration",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCollaborationTile(
                        context: context,
                        collaboration: viewModel.highestPaidCollaboration!,
                      ),
                    ] else ...[
                      _buildEmptyState(context),
                    ],
                  ],
                ),
              ),
            );
            } else {
              // Show dashboard with collaborations
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome message
                      Text(
                        AppLocalizations.of(context)?.dashboardWelcome ?? "Welcome back! 👋",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Time period selector
                      Row(
                        children: [
                          
                          SizedBox(
                            width: 120,
                            child: DropdownButtonFormField<TimePeriod>(
                              value: viewModel.selectedTimePeriod,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Theme.of(context).colorScheme.surface,
                              ),
                              items: TimePeriod.values.map((period) {
                                String label;
                                switch (period) {
                                  case TimePeriod.week:
                                    label = AppLocalizations.of(context)?.week ?? "Week";
                                    break;
                                  case TimePeriod.month:
                                    label = AppLocalizations.of(context)?.month ?? "Month";
                                    break;
                                  case TimePeriod.year:
                                    label = AppLocalizations.of(context)?.year ?? "Year";
                                    break;
                                  case TimePeriod.overall:
                                    label = AppLocalizations.of(context)?.overall ?? "Overall";
                                    break;
                                }
                                return DropdownMenuItem(
                                  value: period,
                                  child: Text(label),
                                );
                              }).toList(),
                              onChanged: (TimePeriod? newValue) {
                                if (newValue != null) {
                                  viewModel.setTimePeriod(newValue);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Metrics tiles
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.8,
                        children: [
                          _buildMetricTile(
                            context: context,
                            title: AppLocalizations.of(context)?.totalEarnings ?? "Total Earnings",
                            value: NumberFormat.currency(
                              locale: Localizations.localeOf(context).toString(),
                              symbol: CurrencyUtils.getCurrencySymbol(),
                            ).format(viewModel.totalEarnings),
                            icon: CurrencyUtils.getCurrencyIcon(),
                            color: Colors.green,
                            subtitle: AppLocalizations.of(context)?.allTime ?? "All time",
                          ),
                          _buildMetricTile(
                            context: context,
                            title: AppLocalizations.of(context)?.totalCollaborations ?? "Total Collaborations",
                            value: viewModel.totalCollaborations.toString(),
                            icon: Icons.handshake,
                            color: AppColors.primaryPink,
                            subtitle: AppLocalizations.of(context)?.allTime ?? "All time",
                          ),
                          _buildMetricTile(
                            context: context,
                            title: AppLocalizations.of(context)?.activeCollaborations ?? "Active",
                            value: viewModel.activeCollaborations.toString(),
                            icon: Icons.trending_up,
                            color: Colors.blue,
                            subtitle: AppLocalizations.of(context)?.inProgress ?? "In progress",
                          ),
                          _buildMetricTile(
                            context: context,
                            title: AppLocalizations.of(context)?.completedCollaborations ?? "Completed",
                            value: viewModel.completedCollaborations.toString(),
                            icon: Icons.check_circle,
                            color: Colors.orange,
                            subtitle: AppLocalizations.of(context)?.finished ?? "Finished",
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Highest paid collaboration tile
                      if (viewModel.highestPaidCollaboration != null) ...[
                        Text(
                          AppLocalizations.of(context)?.highestPaidCollab ?? "Highest Paid Collaboration",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildCollaborationTile(
                          context: context,
                          collaboration: viewModel.highestPaidCollaboration!,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 14,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 1),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 1),
          Flexible(
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 9,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollaborationTile({
    required BuildContext context,
    required collaboration,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.green,
                  size: 24,
                ),
              ),
              const Spacer(),
              Text(
                NumberFormat.currency(
                  locale: Localizations.localeOf(context).toString(),
                  symbol: CurrencyUtils.getCurrencySymbol(),
                ).format(collaboration.fee.amount),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            collaboration.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          if (collaboration.partner.name.isNotEmpty) ...[
            Text(
              "${AppLocalizations.of(context)?.brand ?? "Brand"}: ${collaboration.partner.name}",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            "${AppLocalizations.of(context)?.deadline ?? "Deadline"}: ${DateFormat.yMd(Localizations.localeOf(context).toString()).format(collaboration.deadline.date)}",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.handshake_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)?.createFirstCollab ?? "Create your first collaboration to see your dashboard",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CollaborationWizard(),
                ),
              );
            },
            style: AppColors.primaryButtonStyle,
            icon: const Icon(Icons.add, size: 20),
            label: Text(
              AppLocalizations.of(context)?.createCollaboration ?? "Create Collaboration",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
