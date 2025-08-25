import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/chat.dart';
import 'chat_conversation_screen.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
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
        title: const Text('Chat'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        actions: [
          IconButton(
            onPressed: () {
              // Start new chat
              _showNewChatDialog();
            },
            icon: const Icon(Icons.edit),
            tooltip: 'New chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),
          
          // Chat List
          Expanded(
            child: _buildChatList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewChatDialog();
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.chat, color: AppTheme.white),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search chats...',
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

  Widget _buildChatList() {
    // Mock data for demonstration
    final mockChats = [
      Chat(
        id: '1',
        name: 'John Doe',
        type: ChatType.direct,
        participantIds: ['user1', 'current_user'],
        lastMessagePreview: 'Hey, how are you doing?',
        lastMessageAt: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Chat(
        id: '2',
        name: 'Marketing Team',
        type: ChatType.group,
        participantIds: ['user1', 'user2', 'user3', 'current_user'],
        lastMessagePreview: 'Sarah: The campaign is ready for launch',
        lastMessageAt: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Chat(
        id: '3',
        name: 'Project Alpha',
        type: ChatType.group,
        participantIds: ['user1', 'user4', 'user5', 'current_user'],
        lastMessagePreview: 'Mike: Updated the requirements document',
        lastMessageAt: DateTime.now().subtract(const Duration(hours: 3)),
        unreadCount: 1,
        isPinned: true,
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      Chat(
        id: '4',
        name: 'Family',
        type: ChatType.community,
        participantIds: ['family1', 'family2', 'family3', 'current_user'],
        lastMessagePreview: 'Mom: Don\'t forget dinner on Sunday!',
        lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    // Filter chats based on search query
    final filteredChats = mockChats.where((chat) {
      return chat.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             (chat.lastMessagePreview?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();

    // Sort chats: pinned first, then by last message time
    filteredChats.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      
      if (a.lastMessageAt != null && b.lastMessageAt != null) {
        return b.lastMessageAt!.compareTo(a.lastMessageAt!);
      }
      return 0;
    });

    if (filteredChats.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
        return _buildChatItem(chat);
      },
    );
  }

  Widget _buildChatItem(Chat chat) {
    return ListTile(
      leading: _buildChatAvatar(chat),
      title: Row(
        children: [
          if (chat.isPinned)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(
                Icons.push_pin,
                size: 16,
                color: AppTheme.secondaryText,
              ),
            ),
          Expanded(
            child: Text(
              chat.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: chat.hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (chat.lastMessageAt != null)
            Text(
              _formatTimestamp(chat.lastMessageAt!),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              chat.lastMessagePreview ?? 'No messages yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: chat.hasUnreadMessages ? AppTheme.primaryText : AppTheme.secondaryText,
                fontWeight: chat.hasUnreadMessages ? FontWeight.w500 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (chat.hasUnreadMessages)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(
                  color: AppTheme.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        // Navigate to chat screen
        _openChat(chat);
      },
      onLongPress: () {
        // Show chat options
        _showChatOptions(chat);
      },
    );
  }

  Widget _buildChatAvatar(Chat chat) {
    if (chat.isDirectMessage) {
      // For direct messages, show user avatar
      return CircleAvatar(
        backgroundColor: AppTheme.primaryBlue,
        child: Text(
          chat.name[0].toUpperCase(),
          style: const TextStyle(
            color: AppTheme.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      // For group chats, show group icon
      return CircleAvatar(
        backgroundColor: chat.type == ChatType.community 
            ? AppTheme.successGreen 
            : AppTheme.warningOrange,
        child: Icon(
          chat.type == ChatType.community 
              ? Icons.people 
              : Icons.group,
          color: AppTheme.white,
        ),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppTheme.secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty ? 'No chats found' : 'No chats yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty 
                ? 'Try searching with different keywords'
                : 'Start a conversation with your team',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showNewChatDialog,
              icon: const Icon(Icons.chat),
              label: const Text('Start a chat'),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start a new chat'),
        content: const Text('Choose how you want to start chatting'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Start direct message
            },
            child: const Text('Direct message'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Create group chat
            },
            child: const Text('Group chat'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _openChat(Chat chat) {
    // Navigate to individual chat screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatConversationScreen(chat: chat),
      ),
    );
  }

  void _showChatOptions(Chat chat) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(chat.isPinned ? Icons.push_pin_outlined : Icons.push_pin),
            title: Text(chat.isPinned ? 'Unpin chat' : 'Pin chat'),
            onTap: () {
              Navigator.of(context).pop();
              // Toggle pin status
            },
          ),
          ListTile(
            leading: Icon(chat.isMuted ? Icons.volume_up : Icons.volume_off),
            title: Text(chat.isMuted ? 'Unmute' : 'Mute'),
            onTap: () {
              Navigator.of(context).pop();
              // Toggle mute status
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive),
            title: const Text('Archive'),
            onTap: () {
              Navigator.of(context).pop();
              // Archive chat
            },
          ),
          if (chat.isGroupChat) ...[
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Leave chat'),
              onTap: () {
                Navigator.of(context).pop();
                // Leave group chat
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.delete, color: AppTheme.errorRed),
            title: const Text('Delete chat', style: TextStyle(color: AppTheme.errorRed)),
            onTap: () {
              Navigator.of(context).pop();
              // Delete chat
            },
          ),
        ],
      ),
    );
  }
}