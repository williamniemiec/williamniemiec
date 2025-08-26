import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/blood_pressure_provider.dart';
import '../widgets/latest_reading_card.dart';
import '../widgets/add_reading_dialog.dart';
import '../widgets/quick_stats_card.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  @override
  void initState() {
    super.initState();
    // Load readings when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BloodPressureProvider>().loadReadings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Pressure Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<BloodPressureProvider>().loadReadings();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<BloodPressureProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: AppConstants.mediumSpacing),
                  Text(
                    'Error loading data',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppConstants.smallSpacing),
                  Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.mediumSpacing),
                  ElevatedButton(
                    onPressed: () {
                      provider.loadReadings();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadReadings(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppConstants.mediumSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message
                  _buildWelcomeSection(context),
                  const SizedBox(height: AppConstants.largeSpacing),
                  
                  // Latest reading card
                  _buildLatestReadingSection(context, provider),
                  const SizedBox(height: AppConstants.largeSpacing),
                  
                  // Quick stats
                  _buildQuickStatsSection(context, provider),
                  const SizedBox(height: AppConstants.largeSpacing),
                  
                  // Quick actions
                  _buildQuickActionsSection(context),
                  const SizedBox(height: AppConstants.largeSpacing),
                  
                  // Health tip
                  _buildHealthTipSection(context),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReadingDialog(context),
        tooltip: 'Add New Reading',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final now = DateTime.now();
    String greeting;
    
    if (now.hour < 12) {
      greeting = 'Good Morning';
    } else if (now.hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.smallSpacing),
        Text(
          'Track your blood pressure and stay healthy',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLatestReadingSection(BuildContext context, BloodPressureProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Reading',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.mediumSpacing),
        LatestReadingCard(reading: provider.latestReading),
      ],
    );
  }

  Widget _buildQuickStatsSection(BuildContext context, BloodPressureProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.mediumSpacing),
        QuickStatsCard(readings: provider.readings),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.mediumSpacing),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.history,
                title: 'View History',
                subtitle: 'See all readings',
                onTap: () {
                  // Navigate to history tab
                  final mainScreenState = context.findAncestorStateOfType<State>();
                  if (mainScreenState != null) {
                    // This would require passing a callback or using a different navigation approach
                  }
                },
              ),
            ),
            const SizedBox(width: AppConstants.mediumSpacing),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.analytics,
                title: 'View Stats',
                subtitle: 'Charts & trends',
                onTap: () {
                  // Navigate to stats tab
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.mediumBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.mediumSpacing),
          child: Column(
            children: [
              Icon(
                icon,
                size: AppConstants.largeIconSize,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: AppConstants.smallSpacing),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthTipSection(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Colors.blue[700],
                  size: AppConstants.mediumIconSize,
                ),
                const SizedBox(width: AppConstants.smallSpacing),
                Text(
                  'Health Tip',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.smallSpacing),
            Text(
              'Measure your blood pressure at the same time each day for more accurate tracking. Morning measurements are often recommended.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddReadingDialog(),
    );
  }
}