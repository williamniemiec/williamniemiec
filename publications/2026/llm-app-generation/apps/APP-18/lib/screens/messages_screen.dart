import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_app_bar.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final List<Map<String, dynamic>> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() {
    // Load sample conversations
    setState(() {
      _conversations.addAll([
        {
          'id': '1',
          'username': 'sarah_designs',
          'displayName': 'Sarah Wilson',
          'profileImage': 'https://picsum.photos/50/50?random=1',
          'lastMessage': 'Love your home decor pins!',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
          'unreadCount': 2,
          'isOnline': true,
        },
        {
          'id': '2',
          'username': 'mike_chef',
          'displayName': 'Mike Johnson',
          'profileImage': 'https://picsum.photos/50/50?random=2',
          'lastMessage': 'Thanks for sharing that recipe',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'unreadCount': 0,
          'isOnline': false,
        },
        {
          'id': '3',
          'username': 'emma_travel',
          'displayName': 'Emma Davis',
          'profileImage': 'https://picsum.photos/50/50?random=3',
          'lastMessage': 'Where did you find this travel inspiration?',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
          'unreadCount': 1,
          'isOnline': true,
        },
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'Messages',
        actions: [
          IconButton(
            onPressed: _startNewConversation,
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'New Message',
          ),
        ],
      ),
      body: _conversations.isEmpty
          ? _buildEmptyState()
          : _buildConversationsList(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppTheme.grey400,
          ),
          SizedBox(height: AppTheme.spacingMedium),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: AppTheme.fontSizeLarge,
              color: AppTheme.textSecondary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
          SizedBox(height: AppTheme.spacingSmall),
          Text(
            'Start a conversation by sharing a pin',
            style: TextStyle(
              fontSize: AppTheme.fontSizeMedium,
              color: AppTheme.textTertiary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsList() {
    return ListView.builder(
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        final conversation = _conversations[index];
        return _buildConversationTile(conversation);
      },
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> conversation) {
    final hasUnread = conversation['unreadCount'] > 0;
    final timestamp = conversation['timestamp'] as DateTime;
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMedium,
        vertical: AppTheme.spacingSmall,
      ),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.grey300,
            backgroundImage: NetworkImage(conversation['profileImage']),
          ),
          if (conversation['isOnline'])
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppTheme.successColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        conversation['displayName'],
        style: TextStyle(
          fontSize: AppTheme.fontSizeMedium,
          fontWeight: hasUnread ? AppTheme.fontWeightSemiBold : AppTheme.fontWeightRegular,
          color: AppTheme.textPrimary,
          fontFamily: AppTheme.fontFamily,
        ),
      ),
      subtitle: Text(
        conversation['lastMessage'],
        style: TextStyle(
          fontSize: AppTheme.fontSizeSmall,
          color: hasUnread ? AppTheme.textPrimary : AppTheme.textSecondary,
          fontWeight: hasUnread ? AppTheme.fontWeightMedium : AppTheme.fontWeightRegular,
          fontFamily: AppTheme.fontFamily,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTimestamp(timestamp),
            style: TextStyle(
              fontSize: AppTheme.fontSizeXSmall,
              color: hasUnread ? AppTheme.primaryColor : AppTheme.textTertiary,
              fontWeight: hasUnread ? AppTheme.fontWeightMedium : AppTheme.fontWeightRegular,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
          if (hasUnread) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                conversation['unreadCount'].toString(),
                style: const TextStyle(
                  color: AppTheme.white,
                  fontSize: 10,
                  fontWeight: AppTheme.fontWeightSemiBold,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () => _openConversation(conversation),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _openConversation(Map<String, dynamic> conversation) {
    Navigator.pushNamed(
      context,
      '/conversation',
      arguments: conversation,
    );
  }

  void _startNewConversation() {
    Navigator.pushNamed(context, '/new_message');
  }
}