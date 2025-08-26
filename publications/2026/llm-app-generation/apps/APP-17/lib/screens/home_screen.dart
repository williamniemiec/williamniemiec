import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../providers/tea_provider.dart';
import '../models/chat_message.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/feature_selection_card.dart';
import '../widgets/subscription_banner.dart';
import 'subscription_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  FeatureType? _selectedFeature;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppConstants.shortAnimation,
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final provider = Provider.of<TeaProvider>(context, listen: false);
    
    _messageController.clear();
    
    await provider.sendMessage(
      message,
      featureType: _selectedFeature ?? FeatureType.generalAdvice,
    );
    
    _scrollToBottom();
  }

  Future<void> _selectFeature(FeatureType featureType) async {
    setState(() {
      _selectedFeature = featureType;
    });

    // Show feature-specific prompt
    String prompt = _getFeaturePrompt(featureType);
    _messageController.text = prompt;
  }

  String _getFeaturePrompt(FeatureType featureType) {
    switch (featureType) {
      case FeatureType.chatAnalysis:
        return "I'd like to analyze a dating conversation. Let me upload a screenshot...";
      case FeatureType.profileRoast:
        return "Please roast my dating profile and give me feedback on how to improve it.";
      case FeatureType.bioGenerator:
        return "Help me create a compelling dating bio. My interests include: ";
      case FeatureType.rizzGenerator:
        return "I need some clever pickup lines and conversation starters.";
      case FeatureType.generalAdvice:
        return "I have a dating question...";
    }
  }

  Future<void> _pickImages() async {
    final provider = Provider.of<TeaProvider>(context, listen: false);
    final images = await provider.pickImages();
    
    if (images.isNotEmpty) {
      // For now, we'll just show a message that images were selected
      // In a real app, you'd handle the image upload here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected ${images.length} image(s)'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.local_cafe,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Tea'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Show chat history or clear option
              _showChatOptions();
            },
          ),
          IconButton(
            icon: const Icon(Icons.workspace_premium),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SubscriptionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<TeaProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Subscription banner for free users
              if (!provider.isPremium) const SubscriptionBanner(),
              
              // Feature selection (show when no messages)
              if (provider.chatHistory.isEmpty) ...[
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppTheme.defaultPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How can I help you today?',
                          style: AppTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose a feature to get started, or just ask me anything!',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Feature cards
                        FeatureSelectionCard(
                          title: 'Analyze Chat',
                          description: 'Upload a screenshot and get witty reply suggestions',
                          icon: Icons.chat_bubble_outline,
                          gradient: AppTheme.primaryGradient,
                          onTap: () => _selectFeature(FeatureType.chatAnalysis),
                          remainingUses: provider.getRemainingUsage('chatAnalysis'),
                          isPremium: provider.isPremium,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        FeatureSelectionCard(
                          title: 'Roast My Profile',
                          description: 'Get honest feedback and improvement tips',
                          icon: Icons.person_outline,
                          gradient: AppTheme.secondaryGradient,
                          onTap: () => _selectFeature(FeatureType.profileRoast),
                          remainingUses: provider.getRemainingUsage('profileRoast'),
                          isPremium: provider.isPremium,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        FeatureSelectionCard(
                          title: 'Generate Bio',
                          description: 'Create compelling dating profile bios',
                          icon: Icons.edit_outlined,
                          gradient: AppTheme.accentGradient,
                          onTap: () => _selectFeature(FeatureType.bioGenerator),
                          remainingUses: provider.getRemainingUsage('bioGenerator'),
                          isPremium: provider.isPremium,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        FeatureSelectionCard(
                          title: 'Rizz Generator',
                          description: 'Get clever pickup lines and conversation starters',
                          icon: Icons.favorite_outline,
                          gradient: AppTheme.primaryGradient,
                          onTap: () => _selectFeature(FeatureType.rizzGenerator),
                          remainingUses: provider.getRemainingUsage('rizzGenerator'),
                          isPremium: provider.isPremium,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Chat messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: AppTheme.defaultPadding,
                    itemCount: provider.chatHistory.length,
                    itemBuilder: (context, index) {
                      final message = provider.chatHistory[index];
                      return ChatBubble(
                        message: message,
                        onCopy: (text) {
                          // Copy to clipboard functionality would go here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied to clipboard'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
              
              // Error message
              if (provider.error != null)
                Container(
                  width: double.infinity,
                  padding: AppTheme.defaultPadding,
                  color: AppTheme.errorColor.withOpacity(0.1),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.errorColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.error!,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.errorColor,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: provider.clearError,
                        child: const Text('Dismiss'),
                      ),
                    ],
                  ),
                ),
              
              // Message input
              Container(
                padding: AppTheme.defaultPadding,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.textPrimary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Image picker button
                    IconButton(
                      icon: const Icon(Icons.image_outlined),
                      onPressed: _pickImages,
                      color: AppTheme.primaryColor,
                    ),
                    
                    // Text input
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: _selectedFeature != null
                              ? 'Ask about ${_getFeatureName(_selectedFeature!)}'
                              : 'Ask me anything about dating...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppTheme.backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Send button
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: provider.isLoading ? null : _sendMessage,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getFeatureName(FeatureType featureType) {
    switch (featureType) {
      case FeatureType.chatAnalysis:
        return 'chat analysis';
      case FeatureType.profileRoast:
        return 'profile roasting';
      case FeatureType.bioGenerator:
        return 'bio generation';
      case FeatureType.rizzGenerator:
        return 'rizz lines';
      case FeatureType.generalAdvice:
        return 'dating advice';
    }
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: AppTheme.defaultPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Clear Chat History'),
                onTap: () {
                  Navigator.pop(context);
                  _clearChatHistory();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _clearChatHistory() async {
    final provider = Provider.of<TeaProvider>(context, listen: false);
    await provider.clearChatHistory();
    setState(() {
      _selectedFeature = null;
    });
  }
}