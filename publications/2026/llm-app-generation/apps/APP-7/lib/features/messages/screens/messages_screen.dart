import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/message.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/conversation_tile.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
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
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _startNewConversation,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_searchQuery.isNotEmpty) _buildSearchBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshConversations,
              child: _buildConversationsList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildConversationsList() {
    final conversations = _getFilteredConversations();

    if (conversations.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        return ConversationTile(
          conversation: conversations[index],
          onTap: () => _openConversation(conversations[index]),
          onLongPress: () => _showConversationOptions(conversations[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No messages yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Start a conversation with your teachers',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: _startNewConversation,
            icon: const Icon(Icons.add),
            label: const Text('New Message'),
          ),
        ],
      ),
    );
  }

  List<Conversation> _getFilteredConversations() {
    final conversations = _getMockConversations();
    
    if (_searchQuery.isEmpty) {
      return conversations;
    }

    return conversations.where((conversation) {
      return conversation.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          conversation.participants.any((participant) =>
              participant.name.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  List<Conversation> _getMockConversations() {
    return [
      Conversation(
        id: '1',
        title: 'Ms. Johnson',
        type: ConversationType.direct,
        participantIds: ['teacher1', 'parent1'],
        participants: [
          ConversationParticipant(
            userId: 'teacher1',
            name: 'Ms. Johnson',
            role: 'Teacher',
            isActive: true,
          ),
        ],
        lastMessage: Message(
          id: 'msg1',
          conversationId: '1',
          senderId: 'teacher1',
          senderName: 'Ms. Johnson',
          content: 'Thank you for helping with the field trip!',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Conversation(
        id: '2',
        title: 'Grade 3 Parents',
        type: ConversationType.group,
        participantIds: ['teacher2', 'parent1', 'parent2', 'parent3'],
        participants: [
          ConversationParticipant(
            userId: 'teacher2',
            name: 'Mr. Davis',
            role: 'Teacher',
            isActive: true,
          ),
        ],
        lastMessage: Message(
          id: 'msg2',
          conversationId: '2',
          senderId: 'parent2',
          senderName: 'Sarah Wilson',
          content: 'What time should we arrive for the presentation?',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        unreadCount: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Conversation(
        id: '3',
        title: 'Principal Dr. Smith',
        type: ConversationType.direct,
        participantIds: ['principal1', 'parent1'],
        participants: [
          ConversationParticipant(
            userId: 'principal1',
            name: 'Dr. Smith',
            role: 'Principal',
            isActive: true,
          ),
        ],
        lastMessage: Message(
          id: 'msg3',
          conversationId: '3',
          senderId: 'principal1',
          senderName: 'Dr. Smith',
          content: 'I wanted to follow up on our meeting yesterday.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        unreadCount: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void _toggleSearch() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _searchQuery = ' '; // Trigger search bar display
      } else {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  void _startNewConversation() {
    // TODO: Navigate to new conversation screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New conversation feature coming soon!')),
    );
  }

  void _openConversation(Conversation conversation) {
    // TODO: Navigate to conversation detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening conversation with ${conversation.title}')),
    );
  }

  void _showConversationOptions(Conversation conversation) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.volume_off),
            title: Text(conversation.isMuted ? 'Unmute' : 'Mute'),
            onTap: () {
              Navigator.pop(context);
              _toggleMute(conversation);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              _deleteConversation(conversation);
            },
          ),
        ],
      ),
    );
  }

  void _toggleMute(Conversation conversation) {
    // TODO: Implement mute/unmute functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          conversation.isMuted 
              ? 'Conversation unmuted' 
              : 'Conversation muted',
        ),
      ),
    );
  }

  void _deleteConversation(Conversation conversation) {
    // TODO: Implement delete functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conversation deleted')),
    );
  }

  Future<void> _refreshConversations() async {
    // TODO: Implement refresh functionality
    await Future.delayed(const Duration(seconds: 1));
  }
}