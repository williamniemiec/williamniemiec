import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_theme.dart';
import '../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(String)? onCopy;

  const ChatBubble({
    super.key,
    required this.message,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    final isLoading = message.isLoading;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatar(false),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser 
                    ? AppTheme.userMessageColor 
                    : AppTheme.assistantMessageColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.textPrimary.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Feature type indicator
                  if (message.featureType != null && !isUser)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getFeatureColor(message.featureType!).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getFeatureDisplayName(message.featureType!),
                        style: AppTheme.labelSmall.copyWith(
                          color: _getFeatureColor(message.featureType!),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  
                  // Message content
                  if (isLoading)
                    _buildLoadingIndicator()
                  else
                    _buildMessageContent(isUser),
                  
                  // Images
                  if (message.imageUrls != null && message.imageUrls!.isNotEmpty)
                    _buildImageGrid(),
                  
                  // Timestamp and actions
                  if (!isLoading)
                    _buildMessageFooter(isUser),
                ],
              ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            _buildAvatar(true),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: isUser ? AppTheme.primaryGradient : AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        isUser ? Icons.person : Icons.local_cafe,
        size: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor.withOpacity(0.7),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Thinking...',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageContent(bool isUser) {
    return SelectableText(
      message.content,
      style: AppTheme.bodyMedium.copyWith(
        color: isUser 
            ? AppTheme.userMessageTextColor 
            : AppTheme.assistantMessageTextColor,
        height: 1.4,
      ),
    );
  }

  Widget _buildImageGrid() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: message.imageUrls!.map((imageUrl) {
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.backgroundColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    color: AppTheme.textTertiary,
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessageFooter(bool isUser) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _formatTimestamp(message.timestamp),
            style: AppTheme.labelSmall.copyWith(
              color: isUser 
                  ? AppTheme.userMessageTextColor.withOpacity(0.7)
                  : AppTheme.textTertiary,
            ),
          ),
          
          if (!isUser && onCopy != null)
            InkWell(
              onTap: () => _copyToClipboard(),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.copy,
                  size: 16,
                  color: AppTheme.textTertiary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: message.content));
    onCopy?.call(message.content);
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  Color _getFeatureColor(FeatureType featureType) {
    switch (featureType) {
      case FeatureType.chatAnalysis:
        return AppTheme.primaryColor;
      case FeatureType.profileRoast:
        return AppTheme.secondaryColor;
      case FeatureType.bioGenerator:
        return AppTheme.accentColor;
      case FeatureType.rizzGenerator:
        return AppTheme.primaryColor;
      case FeatureType.generalAdvice:
        return AppTheme.infoColor;
    }
  }

  String _getFeatureDisplayName(FeatureType featureType) {
    switch (featureType) {
      case FeatureType.chatAnalysis:
        return 'Chat Analysis';
      case FeatureType.profileRoast:
        return 'Profile Roast';
      case FeatureType.bioGenerator:
        return 'Bio Generator';
      case FeatureType.rizzGenerator:
        return 'Rizz Generator';
      case FeatureType.generalAdvice:
        return 'Dating Advice';
    }
  }
}