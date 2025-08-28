import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers/chat_provider.dart';
import '../../../core/providers/subscription_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/conversation_sidebar.dart';
import '../widgets/voice_mode_overlay.dart';
import '../widgets/model_selector.dart';
import '../../settings/screens/settings_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      if (chatProvider.currentConversation == null) {
        chatProvider.createNewConversation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: const ConversationSidebar(),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return Stack(
            children: [
              Column(
                children: [
                  if (chatProvider.currentConversation?.messages.isEmpty ?? true)
                    _buildWelcomeSection(),
                  Expanded(
                    child: _buildMessagesList(chatProvider),
                  ),
                  ChatInput(
                    onSendMessage: _handleSendMessage,
                    onSendImage: _handleSendImage,
                    onToggleVoiceMode: _handleToggleVoiceMode,
                    onGenerateImage: _handleGenerateImage,
                  ),
                ],
              ),
              if (chatProvider.isVoiceMode)
                VoiceModeOverlay(
                  onClose: () => chatProvider.toggleVoiceMode(),
                ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return Column(
            children: [
              const Text('ChatGPT'),
              if (chatProvider.currentConversation != null)
                Text(
                  chatProvider.currentConversation!.title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
            ],
          );
        },
      ),
      centerTitle: true,
      actions: [
        Consumer<SubscriptionProvider>(
          builder: (context, subscriptionProvider, child) {
            if (subscriptionProvider.isPlusSubscriber) {
              return const ModelSelector();
            }
            return const SizedBox.shrink();
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  size: 40,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'How can I help you today?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Ask me anything, upload an image for analysis, or generate creative content.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildSuggestionChips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionChips() {
    final suggestions = [
      'Explain quantum physics',
      'Write a poem',
      'Plan a trip to Japan',
      'Help with coding',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: suggestions.map((suggestion) {
        return ActionChip(
          label: Text(suggestion),
          onPressed: () => _handleSendMessage(suggestion),
          backgroundColor: AppTheme.surfaceColor,
          side: BorderSide.none,
        );
      }).toList(),
    );
  }

  Widget _buildMessagesList(ChatProvider chatProvider) {
    if (chatProvider.currentConversation?.messages.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: chatProvider.currentConversation!.messages.length,
      itemBuilder: (context, index) {
        final message = chatProvider.currentConversation!.messages[index];
        return MessageBubble(
          message: message,
          isLoading: index == chatProvider.currentConversation!.messages.length - 1 &&
                    chatProvider.isLoading,
        );
      },
    );
  }

  void _handleSendMessage(String message) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);

    if (!subscriptionProvider.canSendMessage()) {
      _showLimitReachedDialog('message');
      return;
    }

    chatProvider.sendMessage(message);
    subscriptionProvider.incrementMessageCount();
    _scrollToBottom();
  }

  void _handleSendImage(String imagePath, String prompt) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendImageMessage(imagePath, prompt);
    _scrollToBottom();
  }

  void _handleToggleVoiceMode() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.toggleVoiceMode();
  }

  void _handleGenerateImage(String prompt) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);

    if (!subscriptionProvider.canGenerateImage()) {
      _showLimitReachedDialog('image');
      return;
    }

    chatProvider.generateImage(prompt);
    subscriptionProvider.incrementImageGenerationCount();
    _scrollToBottom();
  }

  void _showLimitReachedDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${type == 'message' ? 'Message' : 'Image Generation'} Limit Reached'),
        content: Text(
          'You\'ve reached your daily ${type == 'message' ? 'message' : 'image generation'} limit. '
          'Upgrade to ChatGPT Plus for unlimited access.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to subscription screen
            },
            child: const Text('Upgrade'),
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}