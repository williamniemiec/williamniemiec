import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/league.dart';
import '../widgets/league_card.dart';
import '../widgets/create_league_fab.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('My Leagues'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Drafting'),
            Tab(text: 'Completed'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          if (appProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (appProvider.userLeagues.isEmpty) {
            return _buildEmptyState(context);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildLeaguesList(
                appProvider.userLeagues
                    .where((l) => l.isInSeason)
                    .toList(),
                'No active leagues',
              ),
              _buildLeaguesList(
                appProvider.userLeagues
                    .where((l) => l.isDrafting)
                    .toList(),
                'No leagues currently drafting',
              ),
              _buildLeaguesList(
                appProvider.userLeagues
                    .where((l) => l.isComplete)
                    .toList(),
                'No completed leagues',
              ),
            ],
          );
        },
      ),
      floatingActionButton: const CreateLeagueFab(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_football,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No Leagues Yet',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first league or join one with friends',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to create league
            },
            icon: const Icon(Icons.add),
            label: const Text('Create League'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Navigate to join league
            },
            icon: const Icon(Icons.group_add),
            label: const Text('Join League'),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaguesList(List<League> leagues, String emptyMessage) {
    if (leagues.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<AppProvider>().refresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: leagues.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LeagueCard(league: leagues[index]),
          );
        },
      ),
    );
  }
}