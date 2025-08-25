import 'package:flutter/material.dart';
import '../../../shared/models/chat.dart';
import '../../../shared/models/label.dart';
import '../../../core/constants/app_constants.dart';

class ChatListItem extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: AppConstants.avatarRadius,
        backgroundColor: Theme.of(context).primaryColor,
        backgroundImage: chat.contactAvatar != null
            ? NetworkImage(chat.contactAvatar!)
            : null,
        child: chat.contactAvatar == null
            ? Text(
                _getInitials(chat.contactName),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.contactName,
              style: TextStyle(
                fontWeight: chat.unreadCount > 0 
                    ? FontWeight.bold 
                    : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (chat.lastMessageTime != null)
            Text(
              _formatTime(chat.lastMessageTime!),
              style: TextStyle(
                fontSize: 12,
                color: chat.unreadCount > 0 
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chat.lastMessage != null)
            Text(
              chat.lastMessage!,
              style: TextStyle(
                color: chat.unreadCount > 0 
                    ? Colors.black87
                    : Colors.grey,
                fontWeight: chat.unreadCount > 0 
                    ? FontWeight.w500 
                    : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (chat.labels.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 4,
                children: chat.labels.take(2).map((labelId) {
                  final label = _getLabelById(labelId);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: label?.color.withOpacity(0.2) ?? Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      label?.name ?? labelId,
                      style: TextStyle(
                        fontSize: 10,
                        color: label?.color ?? Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
      trailing: chat.unreadCount > 0
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
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

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  ChatLabel? _getLabelById(String labelId) {
    // Get default labels for now
    final defaultLabels = ChatLabel.getDefaultLabels();
    try {
      return defaultLabels.firstWhere((label) => label.id == labelId);
    } catch (e) {
      return null;
    }
  }
}