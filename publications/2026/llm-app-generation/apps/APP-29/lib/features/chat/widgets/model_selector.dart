import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/chat_provider.dart';
import '../../../core/providers/subscription_provider.dart';
import '../../../core/theme/app_theme.dart';

class ModelSelector extends StatelessWidget {
  const ModelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, SubscriptionProvider>(
      builder: (context, chatProvider, subscriptionProvider, child) {
        if (!subscriptionProvider.isPlusSubscriber) {
          return const SizedBox.shrink();
        }

        return PopupMenuButton<String>(
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getModelDisplayName(chatProvider.selectedModel),
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.primaryColor,
                  size: 16,
                ),
              ],
            ),
          ),
          onSelected: (model) {
            chatProvider.setSelectedModel(model);
          },
          itemBuilder: (context) {
            return chatProvider.availableModels.map((model) {
              final isSelected = chatProvider.selectedModel == model;
              final modelInfo = _getModelInfo(model);
              
              return PopupMenuItem<String>(
                value: model,
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      modelInfo['name']!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                                      ),
                                    ),
                                    if (modelInfo['badge'] != null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _getBadgeColor(modelInfo['badge']!),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          modelInfo['badge']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  modelInfo['description']!,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList();
          },
        );
      },
    );
  }

  String _getModelDisplayName(String model) {
    switch (model) {
      case 'gpt-3.5-turbo':
        return 'GPT-3.5';
      case 'gpt-4':
        return 'GPT-4';
      case 'gpt-4-turbo':
        return 'GPT-4 Turbo';
      case 'gpt-4o':
        return 'GPT-4o';
      default:
        return model;
    }
  }

  Map<String, String?> _getModelInfo(String model) {
    switch (model) {
      case 'gpt-3.5-turbo':
        return {
          'name': 'GPT-3.5 Turbo',
          'description': 'Fast and efficient for most tasks',
          'badge': null,
        };
      case 'gpt-4':
        return {
          'name': 'GPT-4',
          'description': 'More capable, better at complex tasks',
          'badge': 'PLUS',
        };
      case 'gpt-4-turbo':
        return {
          'name': 'GPT-4 Turbo',
          'description': 'Latest GPT-4 with improved speed',
          'badge': 'PLUS',
        };
      case 'gpt-4o':
        return {
          'name': 'GPT-4o',
          'description': 'Most advanced model with multimodal capabilities',
          'badge': 'NEW',
        };
      default:
        return {
          'name': model,
          'description': 'AI language model',
          'badge': null,
        };
    }
  }

  Color _getBadgeColor(String badge) {
    switch (badge) {
      case 'PLUS':
        return AppTheme.primaryColor;
      case 'NEW':
        return AppTheme.successColor;
      case 'BETA':
        return Colors.orange;
      default:
        return AppTheme.secondaryColor;
    }
  }
}