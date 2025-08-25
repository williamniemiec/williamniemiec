import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/team.dart';

class TeamsScreen extends ConsumerStatefulWidget {
  const TeamsScreen({super.key});

  @override
  ConsumerState<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends ConsumerState<TeamsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        actions: [
          IconButton(
            onPressed: () {
              // Join team
              _showJoinTeamDialog();
            },
            icon: const Icon(Icons.group_add),
            tooltip: 'Join team',
          ),
          IconButton(
            onPressed: () {
              // Create team
              _showCreateTeamDialog();
            },
            icon: const Icon(Icons.add),
            tooltip: 'Create team',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),
          
          // Teams List
          Expanded(
            child: _buildTeamsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTeamDialog();
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: AppTheme.white),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search teams...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppTheme.lightGray,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildTeamsList() {
    // Mock data for demonstration
    final mockTeams = [
      Team(
        id: '1',
        name: 'Marketing Team',
        description: 'Marketing campaigns and strategies',
        ownerId: 'owner1',
        memberIds: ['user1', 'user2', 'user3'],
        adminIds: ['admin1'],
        channels: [
          Channel(
            id: 'ch1',
            name: 'General',
            teamId: '1',
            type: ChannelType.general,
            unreadCount: 3,
            lastMessageAt: DateTime.now().subtract(const Duration(minutes: 30)),
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
            updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
          Channel(
            id: 'ch2',
            name: 'Campaigns',
            teamId: '1',
            type: ChannelType.standard,
            unreadCount: 1,
            lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
            createdAt: DateTime.now().subtract(const Duration(days: 25)),
            updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ],
        type: TeamType.standard,
        visibility: TeamVisibility.private,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Team(
        id: '2',
        name: 'Development Team',
        description: 'Software development and engineering',
        ownerId: 'owner2',
        memberIds: ['user4', 'user5', 'user6', 'user7'],
        adminIds: ['admin2', 'admin3'],
        channels: [
          Channel(
            id: 'ch3',
            name: 'General',
            teamId: '2',
            type: ChannelType.general,
            unreadCount: 0,
            lastMessageAt: DateTime.now().subtract(const Duration(hours: 1)),
            createdAt: DateTime.now().subtract(const Duration(days: 60)),
            updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          Channel(
            id: 'ch4',
            name: 'Code Reviews',
            teamId: '2',
            type: ChannelType.standard,
            unreadCount: 5,
            lastMessageAt: DateTime.now().subtract(const Duration(minutes: 15)),
            createdAt: DateTime.now().subtract(const Duration(days: 50)),
            updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
          ),
          Channel(
            id: 'ch5',
            name: 'Bug Reports',
            teamId: '2',
            type: ChannelType.standard,
            unreadCount: 2,
            lastMessageAt: DateTime.now().subtract(const Duration(hours: 4)),
            createdAt: DateTime.now().subtract(const Duration(days: 45)),
            updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
          ),
        ],
        type: TeamType.standard,
        visibility: TeamVisibility.private,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      Team(
        id: '3',
        name: 'Project Alpha',
        description: 'Special project team for Alpha initiative',
        ownerId: 'owner3',
        memberIds: ['user8', 'user9'],
        adminIds: ['admin4'],
        channels: [
          Channel(
            id: 'ch6',
            name: 'General',
            teamId: '3',
            type: ChannelType.general,
            unreadCount: 0,
            lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
            createdAt: DateTime.now().subtract(const Duration(days: 14)),
            updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
        type: TeamType.project,
        visibility: TeamVisibility.private,
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    // Filter teams based on search query
    final filteredTeams = mockTeams.where((team) {
      return team.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             (team.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();

    if (filteredTeams.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: filteredTeams.length,
      itemBuilder: (context, index) {
        final team = filteredTeams[index];
        return _buildTeamItem(team);
      },
    );
  }

  Widget _buildTeamItem(Team team) {
    final totalUnreadCount = team.channels.fold<int>(
      0, 
      (sum, channel) => sum + channel.unreadCount,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        leading: _buildTeamAvatar(team),
        title: Row(
          children: [
            Expanded(
              child: Text(
                team.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: totalUnreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (totalUnreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  totalUnreadCount.toString(),
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (team.description != null)
              Text(
                team.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Text(
              '${team.totalMembers} members • ${team.channels.length} channels',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
        children: team.channels.map((channel) => _buildChannelItem(channel)).toList(),
        onExpansionChanged: (expanded) {
          // Handle expansion state change if needed
        },
      ),
    );
  }

  Widget _buildChannelItem(Channel channel) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 72, right: 16),
      leading: Icon(
        _getChannelIcon(channel.type),
        size: 20,
        color: AppTheme.secondaryText,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              '# ${channel.name}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: channel.hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (channel.hasUnreadMessages)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                channel.unreadCount.toString(),
                style: const TextStyle(
                  color: AppTheme.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      subtitle: channel.lastMessageAt != null
          ? Text(
              'Last activity: ${_formatTimestamp(channel.lastMessageAt!)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            )
          : null,
      onTap: () {
        // Navigate to channel
        _openChannel(channel);
      },
    );
  }

  Widget _buildTeamAvatar(Team team) {
    return CircleAvatar(
      backgroundColor: _getTeamColor(team.type),
      child: team.imageUrl != null
          ? ClipOval(
              child: Image.network(
                team.imageUrl!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    team.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            )
          : Text(
              team.name[0].toUpperCase(),
              style: const TextStyle(
                color: AppTheme.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.groups_outlined,
            size: 64,
            color: AppTheme.secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty ? 'No teams found' : 'No teams yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty 
                ? 'Try searching with different keywords'
                : 'Create or join a team to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _showCreateTeamDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Create team'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: _showJoinTeamDialog,
                  icon: const Icon(Icons.group_add),
                  label: const Text('Join team'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getTeamColor(TeamType type) {
    switch (type) {
      case TeamType.standard:
        return AppTheme.primaryBlue;
      case TeamType.community:
        return AppTheme.successGreen;
      case TeamType.educational:
        return AppTheme.warningOrange;
      case TeamType.project:
        return AppTheme.primaryPurple;
    }
  }

  IconData _getChannelIcon(ChannelType type) {
    switch (type) {
      case ChannelType.general:
        return Icons.tag;
      case ChannelType.announcement:
        return Icons.campaign;
      case ChannelType.standard:
        return Icons.tag;
      case ChannelType.files:
        return Icons.folder;
      case ChannelType.wiki:
        return Icons.article;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _showCreateTeamDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create a team'),
        content: const Text('Choose the type of team you want to create'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Create standard team
            },
            child: const Text('Standard team'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Create community
            },
            child: const Text('Community'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showJoinTeamDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join a team'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter team code or search for teams to join'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Team code or name',
                hintText: 'Enter team code or search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Search for teams
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Join team
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  void _openChannel(Channel channel) {
    // Navigate to channel screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening channel: ${channel.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}