import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/models/chat.dart';
import '../../../shared/models/label.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatConversationScreen extends StatefulWidget {
  final Chat chat;

  const ChatConversationScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadMessages(widget.chat.id);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: widget.chat.contactAvatar != null
                  ? NetworkImage(widget.chat.contactAvatar!)
                  : null,
              child: widget.chat.contactAvatar == null
                  ? Text(
                      _getInitials(widget.chat.contactName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.contactName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.chat.contactPhone != null)
                    Text(
                      widget.chat.contactPhone!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // TODO: Implement voice call
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // TODO: Implement video call
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'labels':
                  _showLabelsDialog();
                  break;
                case 'contact_info':
                  _showContactInfo();
                  break;
                case 'archive':
                  // TODO: Implement archive
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'labels',
                child: Text('Manage Labels'),
              ),
              const PopupMenuItem(
                value: 'contact_info',
                child: Text('Contact Info'),
              ),
              const PopupMenuItem(
                value: 'archive',
                child: Text('Archive Chat'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.chat.labels.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.grey[100],
              child: Wrap(
                spacing: 4,
                children: widget.chat.labels.map((labelId) {
                  final label = _getLabelById(labelId);
                  return Chip(
                    label: Text(
                      label?.name ?? labelId,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: label?.color.withOpacity(0.2),
                    side: BorderSide(color: label?.color ?? Colors.grey),
                  );
                }).toList(),
              ),
            ),
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (chatProvider.messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet'),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return MessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          MessageInput(
            onSendMessage: (content, type) {
              context.read<ChatProvider>().sendMessage(
                widget.chat.id,
                content,
                type,
              );
              _scrollToBottom();
            },
            onSendCatalog: () {
              // TODO: Implement catalog sharing
              _showCatalogDialog();
            },
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0][0].toUpperCase();
    }
    return '?';
  }

  ChatLabel? _getLabelById(String labelId) {
    final defaultLabels = ChatLabel.getDefaultLabels();
    try {
      return defaultLabels.firstWhere((label) => label.id == labelId);
    } catch (e) {
      return null;
    }
  }

  void _showLabelsDialog() {
    final defaultLabels = ChatLabel.getDefaultLabels();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Labels'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: defaultLabels.length,
            itemBuilder: (context, index) {
              final label = defaultLabels[index];
              final isSelected = widget.chat.labels.contains(label.id);
              
              return CheckboxListTile(
                title: Text(label.name),
                subtitle: Text(label.description ?? ''),
                value: isSelected,
                activeColor: label.color,
                onChanged: (value) {
                  if (value == true) {
                    context.read<ChatProvider>().applyLabelToChat(
                      widget.chat.id,
                      label.id,
                    );
                  } else {
                    context.read<ChatProvider>().removeLabelFromChat(
                      widget.chat.id,
                      label.id,
                    );
                  }
                  Navigator.pop(context);
                  setState(() {}); // Refresh the UI
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContactInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.chat.contactName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.chat.contactPhone != null)
              Text('Phone: ${widget.chat.contactPhone}'),
            const SizedBox(height: 8),
            Text('Chat created: ${_formatDate(widget.chat.createdAt)}'),
            Text('Last updated: ${_formatDate(widget.chat.updatedAt)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCatalogDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Catalog'),
        content: const Text('This feature will allow you to share products from your catalog.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}