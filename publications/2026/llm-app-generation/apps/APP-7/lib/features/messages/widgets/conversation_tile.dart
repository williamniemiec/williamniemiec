import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/message.dart';
import '../../../core/theme/app_theme.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ConversationTile({
    super.key,
    required this.conversation,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: _buildAvatar(context),
      title: _buildTitle(context),
      subtitle: _buildSubtitle(context),
      trailing: _buildTrailing(context),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (conversation.type == ConversationType.group) {
      return Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.primaryColor,
            child: Icon(
              Icons.group,
              color: Colors.white,
              size: 20,
            ),
          ),
          if (conversation.unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: _buildUnreadBadge(),
            ),
        ],
      );
    }

    // For direct conversations, show the other participant's avatar
    final otherParticipant = conversation.participants.isNotEmpty
        ? conversation.participants.first
        : null;

    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppTheme.primaryColor,
          backgroundImage: otherParticipant?.imageUrl != null
              ? NetworkImage(otherParticipant!.imageUrl!)
              : null,
          child: otherParticipant?.imageUrl == null
              ? Text(
                  otherParticipant?.name.isNotEmpty == true
                      ? otherParticipant!.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              : null,
        ),
        if (conversation.unreadCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: _buildUnreadBadge(),
          ),
        if (otherParticipant?.isActive == true)
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUnreadBadge() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      ),
      child: Text(
        conversation.unreadCount > 99 ? '99+' : conversation.unreadCount.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            conversation.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: conversation.unreadCount > 0 
                  ? FontWeight.w600 
                  : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (conversation.isMuted)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Icon(
              Icons.volume_off,
              size: 16,
              color: Colors.grey[600],
            ),
          ),
        if (conversation.type == ConversationType.group)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Icon(
              Icons.group,
              size: 16,
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    if (conversation.lastMessage == null) {
      return Text(
        'No messages yet',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[500],
        ),
      );
    }

    final lastMessage = conversation.lastMessage!;
    final isOwnMessage = false; // TODO: Check if message is from current user

    return Row(
      children: [
        if (conversation.type == ConversationType.group && !isOwnMessage)
          Text(
            '${lastMessage.senderName}: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: conversation.unreadCount > 0 
                  ? Theme.of(context).textTheme.bodyMedium?.color
                  : Colors.grey[600],
            ),
          ),
        Expanded(
          child: Text(
            _getMessagePreview(lastMessage),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: conversation.unreadCount > 0 
                  ? FontWeight.w500 
                  : FontWeight.normal,
              color: conversation.unreadCount > 0 
                  ? Theme.of(context).textTheme.bodyMedium?.color
                  : Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatDateTime(conversation.updatedAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: conversation.unreadCount > 0 
                ? AppTheme.primaryColor
                : Colors.grey[500],
            fontWeight: conversation.unreadCount > 0 
                ? FontWeight.w600 
                : FontWeight.normal,
          ),
        ),
        if (conversation.lastMessage?.status == MessageStatus.failed)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.error_outline,
              size: 16,
              color: AppTheme.errorColor,
            ),
          ),
      ],
    );
  }

  String _getMessagePreview(Message message) {
    if (message.attachments.isNotEmpty) {
      final attachment = message.attachments.first;
      switch (attachment.type) {
        case AttachmentType.image:
          return '📷 Photo';
        case AttachmentType.video:
          return '🎥 Video';
        case AttachmentType.document:
          return '📄 Document';
        case AttachmentType.audio:
          return '🎵 Audio';
      }
    }

    return message.content;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Today - show time
      return DateFormat('h:mm a').format(dateTime);
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // This week - show day name
      return DateFormat('EEE').format(dateTime);
    } else {
      // Older - show date
      return DateFormat('MM/dd/yy').format(dateTime);
    }
  }
}