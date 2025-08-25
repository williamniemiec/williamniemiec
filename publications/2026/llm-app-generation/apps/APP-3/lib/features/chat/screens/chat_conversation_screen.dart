import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/chat.dart';
import '../../../shared/models/message.dart';
import '../../../shared/models/user.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatConversationScreen extends ConsumerStatefulWidget {
  final Chat chat;

  const ChatConversationScreen({
    super.key,
    required this.chat,
  });

  @override
  ConsumerState<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends ConsumerState<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  
  bool _showEmojiPicker = false;
  bool _isTyping = false;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _messageFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_messageFocusNode.hasFocus && _showEmojiPicker) {
      setState(() {
        _showEmojiPicker = false;
      });
    }
  }

  void _loadMessages() {
    // Mock messages for demonstration
    _messages = [
      Message(
        id: '1',
        senderId: 'user1',
        senderName: 'John Doe',
        content: 'Hey, how are you doing?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        chatId: widget.chat.id,
        status: MessageStatus.read,
      ),
      Message(
        id: '2',
        senderId: 'current_user',
        senderName: 'You',
        content: 'I\'m doing great! Just working on the new project.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        chatId: widget.chat.id,
        status: MessageStatus.read,
      ),
      Message(
        id: '3',
        senderId: 'user1',
        senderName: 'John Doe',
        content: 'That sounds awesome! Can you share some details about it?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        chatId: widget.chat.id,
        status: MessageStatus.read,
      ),
      Message(
        id: '4',
        senderId: 'current_user',
        senderName: 'You',
        content: 'Sure! It\'s a mobile app for team collaboration. We\'re using Flutter for cross-platform development.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        chatId: widget.chat.id,
        status: MessageStatus.read,
      ),
      Message(
        id: '5',
        senderId: 'user1',
        senderName: 'John Doe',
        content: 'Flutter is great! I\'ve been using it for my recent projects too. 🚀',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        chatId: widget.chat.id,
        status: MessageStatus.read,
        reactions: [
          MessageReaction(
            emoji: '👍',
            userIds: ['current_user'],
            count: 1,
          ),
        ],
      ),
    ];
    
    // Sort messages by timestamp
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    setState(() {});
    
    // Scroll to bottom after loading messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _buildMessagesList(),
          ),
          
          // Message Input
          _buildMessageInput(),
          
          // Emoji Picker
          if (_showEmojiPicker) _buildEmojiPicker(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: AppTheme.white,
      title: Row(
        children: [
          _buildChatAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.chat.isDirectMessage)
                  Text(
                    _isTyping ? 'typing...' : 'last seen recently',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.lightBlue,
                    ),
                  )
                else
                  Text(
                    '${widget.chat.participantIds.length} members',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.lightBlue,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (widget.chat.isDirectMessage) ...[
          IconButton(
            onPressed: () {
              // Start voice call
              _startVoiceCall();
            },
            icon: const Icon(Icons.call),
            tooltip: 'Voice call',
          ),
          IconButton(
            onPressed: () {
              // Start video call
              _startVideoCall();
            },
            icon: const Icon(Icons.videocam),
            tooltip: 'Video call',
          ),
        ],
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            if (widget.chat.isGroupChat) ...[
              const PopupMenuItem(
                value: 'view_members',
                child: Text('View members'),
              ),
              const PopupMenuItem(
                value: 'add_members',
                child: Text('Add members'),
              ),
            ],
            const PopupMenuItem(
              value: 'search',
              child: Text('Search in chat'),
            ),
            const PopupMenuItem(
              value: 'mute',
              child: Text('Mute notifications'),
            ),
            const PopupMenuItem(
              value: 'clear_history',
              child: Text('Clear chat history'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChatAvatar() {
    if (widget.chat.isDirectMessage) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: AppTheme.white,
        child: Text(
          widget.chat.name[0].toUpperCase(),
          style: const TextStyle(
            color: AppTheme.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 18,
        backgroundColor: AppTheme.white,
        child: Icon(
          widget.chat.type == ChatType.community 
              ? Icons.people 
              : Icons.group,
          color: AppTheme.primaryBlue,
          size: 20,
        ),
      );
    }
  }

  Widget _buildMessagesList() {
    if (_messages.isEmpty) {
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
              'No messages yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start the conversation by sending a message',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isCurrentUser = message.senderId == 'current_user';
        final showSenderName = !isCurrentUser && 
                               widget.chat.isGroupChat &&
                               (index == 0 || _messages[index - 1].senderId != message.senderId);
        
        return MessageBubble(
          message: message,
          isCurrentUser: isCurrentUser,
          showSenderName: showSenderName,
          onReaction: (emoji) => _addReaction(message, emoji),
          onReply: () => _replyToMessage(message),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return MessageInput(
      controller: _messageController,
      focusNode: _messageFocusNode,
      onSend: _sendMessage,
      onEmojiTap: () {
        setState(() {
          _showEmojiPicker = !_showEmojiPicker;
        });
        if (_showEmojiPicker) {
          _messageFocusNode.unfocus();
        }
      },
      onAttachmentTap: _showAttachmentOptions,
      onTyping: (isTyping) {
        setState(() {
          _isTyping = isTyping;
        });
      },
    );
  }

  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          _messageController.text += emoji.emoji;
        },
        config: Config(
          height: 256,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            columns: 7,
            emojiSizeMax: 32,
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            backgroundColor: AppTheme.lightGray,
            recentsLimit: 28,
            noRecents: const Text(
              'No Recents',
              style: TextStyle(fontSize: 20, color: AppTheme.secondaryText),
              textAlign: TextAlign.center,
            ),
            loadingIndicator: const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current_user',
      senderName: 'You',
      content: content.trim(),
      timestamp: DateTime.now(),
      chatId: widget.chat.id,
      status: MessageStatus.sending,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Simulate message sending
    Future.delayed(const Duration(seconds: 1), () {
      final updatedMessage = newMessage.copyWith(status: MessageStatus.sent);
      final index = _messages.indexWhere((m) => m.id == newMessage.id);
      if (index != -1) {
        setState(() {
          _messages[index] = updatedMessage;
        });
      }
    });
  }

  void _addReaction(Message message, String emoji) {
    // Find existing reaction or create new one
    final existingReactionIndex = message.reactions.indexWhere(
      (reaction) => reaction.emoji == emoji,
    );

    List<MessageReaction> updatedReactions = List.from(message.reactions);

    if (existingReactionIndex != -1) {
      // Toggle existing reaction
      final existingReaction = updatedReactions[existingReactionIndex];
      if (existingReaction.userIds.contains('current_user')) {
        // Remove user's reaction
        final updatedUserIds = existingReaction.userIds
            .where((id) => id != 'current_user')
            .toList();
        
        if (updatedUserIds.isEmpty) {
          updatedReactions.removeAt(existingReactionIndex);
        } else {
          updatedReactions[existingReactionIndex] = MessageReaction(
            emoji: emoji,
            userIds: updatedUserIds,
            count: updatedUserIds.length,
          );
        }
      } else {
        // Add user's reaction
        final updatedUserIds = [...existingReaction.userIds, 'current_user'];
        updatedReactions[existingReactionIndex] = MessageReaction(
          emoji: emoji,
          userIds: updatedUserIds,
          count: updatedUserIds.length,
        );
      }
    } else {
      // Add new reaction
      updatedReactions.add(MessageReaction(
        emoji: emoji,
        userIds: ['current_user'],
        count: 1,
      ));
    }

    // Update message
    final updatedMessage = message.copyWith(reactions: updatedReactions);
    final messageIndex = _messages.indexWhere((m) => m.id == message.id);
    if (messageIndex != -1) {
      setState(() {
        _messages[messageIndex] = updatedMessage;
      });
    }
  }

  void _replyToMessage(Message message) {
    // Set reply context and focus on input
    _messageFocusNode.requestFocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Replying to: ${message.content}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo, color: AppTheme.primaryBlue),
              title: const Text('Photo'),
              onTap: () {
                Navigator.pop(context);
                _attachPhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: AppTheme.primaryBlue),
              title: const Text('Video'),
              onTap: () {
                Navigator.pop(context);
                _attachVideo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file, color: AppTheme.primaryBlue),
              title: const Text('File'),
              onTap: () {
                Navigator.pop(context);
                _attachFile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: AppTheme.primaryBlue),
              title: const Text('Location'),
              onTap: () {
                Navigator.pop(context);
                _shareLocation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'view_members':
        _viewMembers();
        break;
      case 'add_members':
        _addMembers();
        break;
      case 'search':
        _searchInChat();
        break;
      case 'mute':
        _muteChat();
        break;
      case 'clear_history':
        _clearChatHistory();
        break;
    }
  }

  void _startVoiceCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting voice call...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _startVideoCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting video call...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _attachPhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo attachment feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _attachVideo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video attachment feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _attachFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File attachment feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location sharing feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewMembers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('View members feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addMembers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add members feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _searchInChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Search in chat feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _muteChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat muted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearChatHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text('Are you sure you want to clear all messages in this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _messages.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chat history cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}