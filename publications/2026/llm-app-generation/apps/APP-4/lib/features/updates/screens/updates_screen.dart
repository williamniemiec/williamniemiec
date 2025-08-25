import 'package:flutter/material.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen>
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
        title: const Text('Updates'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Status'),
            Tab(text: 'Channels'),
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
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implement menu
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatusTab(),
          _buildChannelsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateStatusDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatusTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // My Status
        ListTile(
          leading: Stack(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          title: const Text(
            'My status',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Tap to add status update'),
          onTap: _showCreateStatusDialog,
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Recent updates',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Sample status updates
        _buildStatusItem(
          'John Smith',
          '2 minutes ago',
          Colors.green,
        ),
        _buildStatusItem(
          'Sarah Johnson',
          '1 hour ago',
          Colors.blue,
        ),
        _buildStatusItem(
          'Mike Wilson',
          '3 hours ago',
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildChannelsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Channels',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Stay updated on topics that matter to you. Find channels to follow below.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        _buildChannelItem(
          'Business News',
          'Latest business updates and trends',
          Icons.business,
          Colors.blue,
        ),
        _buildChannelItem(
          'Marketing Tips',
          'Daily marketing strategies and tips',
          Icons.campaign,
          Colors.orange,
        ),
        _buildChannelItem(
          'Customer Service',
          'Best practices for customer support',
          Icons.support_agent,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatusItem(String name, String time, Color statusColor) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: statusColor, width: 2),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Text(
            name[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(name),
      subtitle: Text(time),
      onTap: () {
        // TODO: View status
        _showStatusDialog(name);
      },
    );
  }

  Widget _buildChannelItem(
    String name,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(name),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: () {
            // TODO: Follow channel
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Following $name')),
            );
          },
          child: const Text('Follow'),
        ),
      ),
    );
  }

  void _showCreateStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Status'),
        content: const Text(
          'Status updates allow you to share photos, videos, and text that disappear after 24 hours.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement status creation
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$name\'s Status'),
        content: const Text('Status viewing feature will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}