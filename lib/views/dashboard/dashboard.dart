import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ugcworks/models/collaboration.dart';
import 'package:ugcworks/repositories/collaborations-repository.dart';
import 'package:ugcworks/l10n/app_localizations.dart';
import 'package:ugcworks/constants/app_colors.dart';
import 'package:ugcworks/utils/theme_utils.dart';

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
        body: Consumer<CollaborationsRepository>(
          builder: (context, repository, _) {
            final collaborations = repository.collaborations;
            
            // Calculate metrics
            final totalEarnings = collaborations.fold<double>(
              0, 
              (sum, collab) => sum + collab.fee.amount,
            );
            
            final totalCollaborations = collaborations.length;
            
            final highestPaidCollab = collaborations.isEmpty 
                ? null 
                : collaborations.reduce((a, b) => 
                    a.fee.amount > b.fee.amount ? a : b,
                  );
            
            final completedCollaborations = collaborations
                .where((c) => c.state == CollabState.Finished)
                .length;
            
            final activeCollaborations = collaborations
                .where((c) => c.state != CollabState.Finished)
                .length;

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20), // Reduced bottom padding
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
                      childAspectRatio: 1.3,
                      children: [
                        _buildMetricTile(
                          context: context,
                          title: AppLocalizations.of(context)?.totalEarnings ?? "Total Earnings",
                          value: NumberFormat.currency(
                            locale: Localizations.localeOf(context).toString(),
                            symbol: "€",
                          ).format(totalEarnings),
                          icon: Icons.euro,
                          color: Colors.green,
                          subtitle: AppLocalizations.of(context)?.allTime ?? "All time",
                        ),
                        _buildMetricTile(
                          context: context,
                          title: AppLocalizations.of(context)?.totalCollaborations ?? "Total Collaborations",
                          value: totalCollaborations.toString(),
                          icon: Icons.handshake,
                          color: AppColors.primaryPink,
                          subtitle: AppLocalizations.of(context)?.allTime ?? "All time",
                        ),
                        _buildMetricTile(
                          context: context,
                          title: AppLocalizations.of(context)?.activeCollaborations ?? "Active",
                          value: activeCollaborations.toString(),
                          icon: Icons.trending_up,
                          color: Colors.blue,
                          subtitle: AppLocalizations.of(context)?.inProgress ?? "In progress",
                        ),
                        _buildMetricTile(
                          context: context,
                          title: AppLocalizations.of(context)?.completedCollaborations ?? "Completed",
                          value: completedCollaborations.toString(),
                          icon: Icons.check_circle,
                          color: Colors.orange,
                          subtitle: AppLocalizations.of(context)?.finished ?? "Finished",
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Highest paid collaboration tile
                    if (highestPaidCollab != null) ...[
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
                        collaboration: highestPaidCollab,
                      ),
                    ] else ...[
                      _buildEmptyState(context),
                    ],
                  ],
                ),
              ),
            );
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
      padding: const EdgeInsets.all(12),
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
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
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
                fontSize: 10,
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
                  symbol: "€",
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
          Text(
            AppLocalizations.of(context)?.noCollaborationsYet ?? "No collaborations yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)?.createFirstCollab ?? "Create your first collaboration to see your dashboard",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
