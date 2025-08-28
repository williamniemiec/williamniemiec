import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/sleeper_pick.dart';
import '../widgets/pick_card.dart';
import '../widgets/balance_card.dart';

class PicksScreen extends StatefulWidget {
  const PicksScreen({super.key});

  @override
  State<PicksScreen> createState() => _PicksScreenState();
}

class _PicksScreenState extends State<PicksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleeper Picks'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Available'),
            Tab(text: 'My Entries'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Navigate to picks history
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () {
              // TODO: Navigate to wallet
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const BalanceCard(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvailablePicks(),
                _buildMyEntries(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePicks() {
    // Mock data for available picks
    final availablePicks = _getMockAvailablePicks();

    if (availablePicks.isEmpty) {
      return _buildEmptyState(
        'No Picks Available',
        'Check back later for new picks',
        Icons.casino_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh available picks
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: availablePicks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PickCard(pick: availablePicks[index]),
          );
        },
      ),
    );
  }

  Widget _buildMyEntries() {
    // Mock data for user entries
    final myEntries = _getMockUserEntries();

    if (myEntries.isEmpty) {
      return _buildEmptyState(
        'No Active Entries',
        'Make your first pick to get started',
        Icons.receipt_long_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh user entries
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: myEntries.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildEntryCard(myEntries[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(PickEntry entry) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Entry #${entry.id.length > 8 ? entry.id.substring(0, 8) : entry.id}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                _buildStatusChip(entry.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatItem('Picks', entry.pickCount.toString()),
                const SizedBox(width: 24),
                _buildStatItem('Entry', '\$${entry.entryAmount.toStringAsFixed(2)}'),
                const SizedBox(width: 24),
                _buildStatItem('Potential', '\$${entry.potentialPayout.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${entry.wonPicks}/${entry.pickCount} picks won',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            if (entry.isSettled && entry.finalPayout != null) ...[
              const SizedBox(height: 8),
              Text(
                'Final Payout: \$${entry.finalPayout!.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: entry.isWon ? AppTheme.successColor : AppTheme.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(EntryStatus status) {
    Color statusColor;
    switch (status) {
      case EntryStatus.won:
        statusColor = AppTheme.successColor;
        break;
      case EntryStatus.lost:
        statusColor = AppTheme.errorColor;
        break;
      case EntryStatus.pending:
        statusColor = AppTheme.warningColor;
        break;
      default:
        statusColor = AppTheme.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayText.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: statusColor,
        ),
      ),
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

  // Mock data methods
  List<SleeperPick> _getMockAvailablePicks() {
    return [
      SleeperPick(
        id: '1',
        playerId: 'player1',
        playerName: 'Josh Allen',
        playerPosition: 'QB',
        playerTeam: 'BUF',
        statType: 'Passing Yards',
        line: 275.5,
        pickType: PickType.more,
        odds: 1.85,
        payout: 1.85,
        gameId: 'game1',
        gameTime: DateTime.now().add(const Duration(hours: 2)),
        opponent: 'MIA',
        status: PickStatus.pending,
      ),
      SleeperPick(
        id: '2',
        playerId: 'player2',
        playerName: 'Derrick Henry',
        playerPosition: 'RB',
        playerTeam: 'TEN',
        statType: 'Rushing Yards',
        line: 85.5,
        pickType: PickType.less,
        odds: 1.92,
        payout: 1.92,
        gameId: 'game2',
        gameTime: DateTime.now().add(const Duration(hours: 4)),
        opponent: 'IND',
        status: PickStatus.pending,
      ),
    ];
  }

  List<PickEntry> _getMockUserEntries() {
    return [
      PickEntry(
        id: 'entry1',
        userId: 'user1',
        picks: _getMockAvailablePicks().take(2).toList(),
        entryAmount: 10.0,
        potentialPayout: 34.22,
        totalOdds: 3.422,
        status: EntryStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
  }
}