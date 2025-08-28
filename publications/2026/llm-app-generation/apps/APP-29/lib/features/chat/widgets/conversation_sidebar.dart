import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/chat_provider.dart';
import '../../../core/providers/subscription_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/conversation.dart';

class ConversationSidebar extends StatelessWidget {
  const ConversationSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildConversationsList(),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'ChatGPT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                chatProvider.createNewConversation();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.add, color: AppTheme.primaryColor),
              label: const Text(
                'New Chat',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryColor,
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsList() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.conversations.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 48,
                    color: AppTheme.textTertiary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No conversations yet',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start a new chat to begin',
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: chatProvider.conversations.length,
          itemBuilder: (context, index) {
            final conversation = chatProvider.conversations[index];
            final isSelected = chatProvider.currentConversation?.id == conversation.id;
            
            return _buildConversationTile(
              context,
              conversation,
              isSelected,
              chatProvider,
            );
          },
        );
      },
    );
  }

  Widget _buildConversationTile(
    BuildContext context,
    Conversation conversation,
    bool isSelected,
    ChatProvider chatProvider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.chat_bubble_outline,
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            size: 20,
          ),
        ),
        title: Text(
          conversation.title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          conversation.preview,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert,
            color: AppTheme.textSecondary,
            size: 20,
          ),
          onSelected: (value) {
            switch (value) {
              case 'delete':
                _showDeleteConfirmation(context, conversation, chatProvider);
                break;
              case 'rename':
                _showRenameDialog(context, conversation, chatProvider);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'rename',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16),
                  SizedBox(width: 8),
                  Text('Rename'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16, color: AppTheme.errorColor),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: AppTheme.errorColor)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          chatProvider.selectConversation(conversation.id);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.textTertiary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Consumer<SubscriptionProvider>(
        builder: (context, subscriptionProvider, child) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: subscriptionProvider.isPlusSubscriber
                      ? AppTheme.primaryColor.withOpacity(0.1)
                      : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscriptionProvider.subscriptionStatusText,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: subscriptionProvider.isPlusSubscriber
                            ? AppTheme.primaryColor
                            : AppTheme.textPrimary,
                      ),
                    ),
                    if (!subscriptionProvider.isPlusSubscriber) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${subscriptionProvider.remainingMessages} messages left today',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!subscriptionProvider.isPlusSubscriber) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to subscription screen
                    },
                    child: const Text('Upgrade to Plus'),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Conversation conversation,
    ChatProvider chatProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: Text('Are you sure you want to delete "${conversation.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              chatProvider.deleteConversation(conversation.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(
    BuildContext context,
    Conversation conversation,
    ChatProvider chatProvider,
  ) {
    final TextEditingController controller = TextEditingController(
      text: conversation.title,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Conversation'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Conversation name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                conversation.title = newTitle;
                chatProvider.notifyListeners();
                Navigator.of(context).pop();
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }
}