import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/automated_message_provider.dart';
import '../../../shared/models/automated_message.dart';

class MessagingSettingsScreen extends StatefulWidget {
  const MessagingSettingsScreen({super.key});

  @override
  State<MessagingSettingsScreen> createState() => _MessagingSettingsScreenState();
}

class _MessagingSettingsScreenState extends State<MessagingSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AutomatedMessageProvider>().loadAutomatedMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messaging Settings'),
      ),
      body: Consumer<AutomatedMessageProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildAutomatedMessagesSection(provider),
              const SizedBox(height: 24),
              _buildQuickRepliesSection(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAutomatedMessagesSection(AutomatedMessageProvider provider) {
    final greetingMessage = provider.getGreetingMessage();
    final awayMessage = provider.getAwayMessage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Automated Messages',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.waving_hand),
                title: const Text('Greeting Message'),
                subtitle: Text(greetingMessage?.isEnabled == true ? 'Enabled' : 'Disabled'),
                trailing: Switch(
                  value: greetingMessage?.isEnabled ?? false,
                  onChanged: (value) {
                    if (greetingMessage != null) {
                      provider.updateAutomatedMessage(
                        greetingMessage.copyWith(isEnabled: value),
                      );
                    }
                  },
                ),
                onTap: () => _showEditMessageDialog(greetingMessage, 'Greeting Message'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Away Message'),
                subtitle: Text(awayMessage?.isEnabled == true ? 'Enabled' : 'Disabled'),
                trailing: Switch(
                  value: awayMessage?.isEnabled ?? false,
                  onChanged: (value) {
                    if (awayMessage != null) {
                      provider.updateAutomatedMessage(
                        awayMessage.copyWith(isEnabled: value),
                      );
                    }
                  },
                ),
                onTap: () => _showEditMessageDialog(awayMessage, 'Away Message'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickRepliesSection(AutomatedMessageProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quick Replies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddQuickReplyDialog(provider),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (provider.quickReplies.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text('No quick replies yet'),
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: provider.quickReplies.map((quickReply) {
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      quickReply.shortcut,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  title: Text(quickReply.message),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditQuickReplyDialog(provider, quickReply);
                      } else if (value == 'delete') {
                        _showDeleteQuickReplyDialog(provider, quickReply);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _showEditMessageDialog(AutomatedMessage? message, String title) {
    if (message == null) return;

    final controller = TextEditingController(text: message.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter your message...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<AutomatedMessageProvider>().updateAutomatedMessage(
                  message.copyWith(content: controller.text),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddQuickReplyDialog(AutomatedMessageProvider provider) {
    final shortcutController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Quick Reply'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: shortcutController,
              decoration: const InputDecoration(
                labelText: 'Shortcut (e.g., /thanks)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (shortcutController.text.isNotEmpty && messageController.text.isNotEmpty) {
                final quickReply = QuickReply(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  shortcut: shortcutController.text,
                  message: messageController.text,
                  createdAt: DateTime.now(),
                );
                provider.addQuickReply(quickReply);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditQuickReplyDialog(AutomatedMessageProvider provider, QuickReply quickReply) {
    final shortcutController = TextEditingController(text: quickReply.shortcut);
    final messageController = TextEditingController(text: quickReply.message);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Quick Reply'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: shortcutController,
              decoration: const InputDecoration(
                labelText: 'Shortcut',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (shortcutController.text.isNotEmpty && messageController.text.isNotEmpty) {
                provider.updateQuickReply(
                  quickReply.copyWith(
                    shortcut: shortcutController.text,
                    message: messageController.text,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteQuickReplyDialog(AutomatedMessageProvider provider, QuickReply quickReply) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quick Reply'),
        content: Text('Are you sure you want to delete "${quickReply.shortcut}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteQuickReply(quickReply.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}