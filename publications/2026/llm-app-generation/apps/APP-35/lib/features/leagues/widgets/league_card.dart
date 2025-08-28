import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/league.dart';

class LeagueCard extends StatelessWidget {
  final League league;

  const LeagueCard({
    super.key,
    required this.league,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.go('/leagues/${league.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildLeagueAvatar(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          league.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildSportChip(),
                            const SizedBox(width: 8),
                            _buildStatusChip(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildLeagueActions(context),
                ],
              ),
              const SizedBox(height: 16),
              _buildLeagueStats(),
              if (league.isDrafting) ...[
                const SizedBox(height: 12),
                _buildDraftInfo(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeagueAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.getSportColor(league.sport),
        borderRadius: BorderRadius.circular(8),
      ),
      child: league.avatar != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                league.avatar!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
              ),
            )
          : _buildDefaultAvatar(),
    );
  }

  Widget _buildDefaultAvatar() {
    IconData icon;
    switch (league.sport.toLowerCase()) {
      case 'nfl':
        icon = Icons.sports_football;
        break;
      case 'nba':
        icon = Icons.sports_basketball;
        break;
      case 'soccer':
        icon = Icons.sports_soccer;
        break;
      default:
        icon = Icons.sports;
    }

    return Icon(
      icon,
      color: Colors.white,
      size: 24,
    );
  }

  Widget _buildSportChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.getSportColor(league.sport).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        league.sport.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppTheme.getSportColor(league.sport),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color statusColor;
    String statusText;

    switch (league.status) {
      case 'drafting':
        statusColor = AppTheme.warningColor;
        statusText = 'DRAFTING';
        break;
      case 'in_season':
        statusColor = AppTheme.successColor;
        statusText = 'ACTIVE';
        break;
      case 'complete':
        statusColor = AppTheme.textSecondary;
        statusText = 'COMPLETE';
        break;
      default:
        statusColor = AppTheme.textSecondary;
        statusText = 'PRE-DRAFT';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildLeagueActions(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'settings':
            // TODO: Navigate to league settings
            break;
          case 'invite':
            // TODO: Show invite dialog
            break;
          case 'leave':
            // TODO: Show leave confirmation
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'invite',
          child: Row(
            children: [
              Icon(Icons.person_add),
              SizedBox(width: 8),
              Text('Invite Friends'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'leave',
          child: Row(
            children: [
              Icon(Icons.exit_to_app, color: AppTheme.errorColor),
              SizedBox(width: 8),
              Text('Leave League', style: TextStyle(color: AppTheme.errorColor)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeagueStats() {
    return Row(
      children: [
        _buildStatItem('Teams', league.totalRosters.toString()),
        const SizedBox(width: 24),
        _buildStatItem('Type', league.leagueType.toUpperCase()),
        const SizedBox(width: 24),
        _buildStatItem('Season', league.season),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDraftInfo(BuildContext context) {
    if (league.draftInfo == null) return const SizedBox.shrink();

    final draftInfo = league.draftInfo!;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.warningColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule,
            color: AppTheme.warningColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Draft in Progress',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.warningColor,
                  ),
                ),
                if (draftInfo.startTime != null)
                  Text(
                    'Started ${_formatDraftTime(draftInfo.startTime!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.go('/leagues/${league.id}/draft'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Join Draft'),
          ),
        ],
      ),
    );
  }

  String _formatDraftTime(DateTime startTime) {
    final now = DateTime.now();
    final difference = now.difference(startTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}