import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/message.dart';
import '../../../core/theme/app_theme.dart';
import 'dart:io';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isLoading;

  const MessageBubble({
    super.key,
    required this.message,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          if (!isUser) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _buildMessageContent(context, isUser),
                const SizedBox(height: 4),
                _buildTimestamp(isUser),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 12),
          if (isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.smart_toy,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isUser) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUser ? AppTheme.primaryColor : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16).copyWith(
          topLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
          topRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.type == MessageType.image && message.imagePath != null)
            _buildImageContent(),
          if (message.type == MessageType.generatedImage && message.imagePath != null)
            _buildGeneratedImageContent(),
          _buildTextContent(isUser),
          if (isLoading) _buildLoadingIndicator(),
          if (!isUser && !isLoading) _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: message.imagePath!.startsWith('http')
            ? CachedNetworkImage(
                imageUrl: message.imagePath!,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
              )
            : Image.file(
                File(message.imagePath!),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildGeneratedImageContent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: message.imagePath!,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            height: 200,
            color: Colors.grey[300],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text('Generated Image', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(bool isUser) {
    return SelectableText(
      message.content,
      style: TextStyle(
        color: isUser ? Colors.white : AppTheme.textPrimary,
        fontSize: 16,
        height: 1.4,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
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
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: message.content));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            color: AppTheme.textSecondary,
          ),
          IconButton(
            icon: const Icon(Icons.thumb_up_outlined, size: 16),
            onPressed: () {
              // Implement feedback functionality
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            color: AppTheme.textSecondary,
          ),
          IconButton(
            icon: const Icon(Icons.thumb_down_outlined, size: 16),
            onPressed: () {
              // Implement feedback functionality
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            color: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildTimestamp(bool isUser) {
    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? 0 : 8,
        right: isUser ? 8 : 0,
      ),
      child: Text(
        _formatTimestamp(message.timestamp),
        style: const TextStyle(
          color: AppTheme.textTertiary,
          fontSize: 12,
        ),
      ),
    );
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
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}