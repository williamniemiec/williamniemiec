import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/routine.dart';

class AutomationsScreen extends StatefulWidget {
  const AutomationsScreen({super.key});

  @override
  State<AutomationsScreen> createState() => _AutomationsScreenState();
}

class _AutomationsScreenState extends State<AutomationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadMockData();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    final mockRoutines = [
      Routine(
        id: '1',
        name: 'Good Morning',
        type: RoutineType.household,
        isEnabled: true,
        starters: [
          RoutineStarter(
            id: 's1',
            type: StarterType.voiceCommand,
            parameters: {'command': 'Good Morning'},
          ),
        ],
        actions: [
          RoutineAction(
            id: 'a1',
            type: ActionType.adjustLights,
            parameters: {'brightness': 80},
          ),
          RoutineAction(
            id: 'a2',
            type: ActionType.setThermostat,
            parameters: {'temperature': 22},
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        lastTriggered: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      Routine(
        id: '2',
        name: 'Good Night',
        type: RoutineType.household,
        isEnabled: true,
        starters: [
          RoutineStarter(
            id: 's2',
            type: StarterType.voiceCommand,
            parameters: {'command': 'Good Night'},
          ),
        ],
        actions: [
          RoutineAction(
            id: 'a3',
            type: ActionType.adjustLights,
            parameters: {'brightness': 0},
          ),
          RoutineAction(
            id: 'a4',
            type: ActionType.setThermostat,
            parameters: {'temperature': 18},
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        lastTriggered: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      Routine(
        id: '3',
        name: 'Movie Time',
        type: RoutineType.personal,
        isEnabled: false,
        starters: [
          RoutineStarter(
            id: 's3',
            type: StarterType.voiceCommand,
            parameters: {'command': 'Movie Time'},
          ),
        ],
        actions: [
          RoutineAction(
            id: 'a5',
            type: ActionType.adjustLights,
            parameters: {'brightness': 20},
          ),
          RoutineAction(
            id: 'a6',
            type: ActionType.playMedia,
            parameters: {'media': 'Netflix'},
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        lastTriggered: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    appProvider.setRoutines(mockRoutines);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                children: [
                  Text(
                    'Automations',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: () => _showHelpDialog(context),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                tabs: const [
                  Tab(text: 'Household'),
                  Tab(text: 'Personal'),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: Consumer<AppProvider>(
                builder: (context, appProvider, child) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRoutinesList(appProvider.householdRoutines),
                      _buildRoutinesList(appProvider.personalRoutines),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateRoutineDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRoutinesList(List<Routine> routines) {
    if (routines.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.autorenew,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'No routines yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Create your first automation routine',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: routines.length,
      itemBuilder: (context, index) {
        final routine = routines[index];
        return _buildRoutineCard(routine);
      },
    );
  }

  Widget _buildRoutineCard(Routine routine) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    routine.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Switch(
                  value: routine.isEnabled,
                  onChanged: (value) => _toggleRoutine(routine.id),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.smallPadding),

            // Starter
            Row(
              children: [
                Icon(
                  Icons.play_arrow,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    routine.primaryStarter,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.smallPadding),

            // Actions
            Row(
              children: [
                Icon(
                  Icons.settings,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${routine.actions.length} actions',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last run: ${_formatLastTriggered(routine.lastTriggered)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => _editRoutine(routine),
                      child: const Text('Edit'),
                    ),
                    TextButton(
                      onPressed: () => _runRoutine(routine),
                      child: const Text('Run'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastTriggered(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _toggleRoutine(String routineId) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.toggleRoutine(routineId);
  }

  void _editRoutine(Routine routine) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${routine.name}')),
    );
  }

  void _runRoutine(Routine routine) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Running ${routine.name}')),
    );
  }

  void _showCreateRoutineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Routine'),
        content: const Text('Routine creation wizard would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Automations'),
        content: const Text(
          'Automations help you control multiple devices with a single command or trigger. '
          'Create routines that run automatically based on time, voice commands, or device states.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}