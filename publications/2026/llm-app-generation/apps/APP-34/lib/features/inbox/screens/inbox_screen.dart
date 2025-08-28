import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user.dart';
import '../../../shared/models/message.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<NotificationItem> _notifications = [
    NotificationItem(
      type: NotificationType.like,
      user: 'john_doe',
      message: 'liked your video',
      time: '2m',
      isRead: false,
    ),
    NotificationItem(
      type: NotificationType.comment,
      user: 'jane_smith',
      message: 'commented on your video: "Amazing!"',
      time: '5m',
      isRead: false,
    ),
    NotificationItem(
      type: NotificationType.follow,
      user: 'mike_wilson',
      message: 'started following you',
      time: '1h',
      isRead: true,
    ),
    NotificationItem(
      type: NotificationType.mention,
      user: 'sarah_jones',
      message: 'mentioned you in a comment',
      time: '2h',
      isRead: true,
    ),
  ];

  final List<ChatItem> _chats = [
    ChatItem(
      user: 'alice_brown',
      lastMessage: 'Hey! Love your latest video 🔥',
      time: '10m',
      unreadCount: 2,
      isOnline: true,
    ),
    ChatItem(
      user: 'bob_taylor',
      lastMessage: 'Thanks for the follow back!',
      time: '1h',
      unreadCount: 0,
      isOnline: false,
    ),
    ChatItem(
      user: 'emma_davis',
      lastMessage: 'Can we collaborate on a video?',
      time: '3h',
      unreadCount: 1,
      isOnline: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Inbox',
                    style: AppTheme.usernameStyle,
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Open settings or search
                    },
                    icon: const Icon(
                      Icons.search,
                      color: AppConstants.iconColor,
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppConstants.dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppConstants.primaryColor,
                labelColor: AppConstants.textPrimaryColor,
                unselectedLabelColor: AppConstants.textSecondaryColor,
                tabs: const [
                  Tab(text: 'All activity'),
                  Tab(text: 'Messages'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNotificationsTab(),
                  _buildMessagesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            color: notification.isRead 
                ? Colors.transparent 
                : AppConstants.surfaceColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Row(
            children: [
              // Notification Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: AppConstants.defaultPadding),
              
              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: AppConstants.textPrimaryColor,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: notification.user,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: ' ${notification.message}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.time,
                      style: const TextStyle(
                        color: AppConstants.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Unread Indicator
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppConstants.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessagesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        return GestureDetector(
          onTap: () {
            // TODO: Navigate to chat screen
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: AppConstants.surfaceColor,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Row(
              children: [
                // Profile Picture with Online Status
                Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppConstants.textSecondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppConstants.backgroundColor,
                      ),
                    ),
                    if (chat.isOnline)
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
                              color: AppConstants.backgroundColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(width: AppConstants.defaultPadding),
                
                // Chat Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            chat.user,
                            style: const TextStyle(
                              color: AppConstants.textPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            chat.time,
                            style: const TextStyle(
                              color: AppConstants.textSecondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessage,
                              style: TextStyle(
                                color: chat.unreadCount > 0
                                    ? AppConstants.textPrimaryColor
                                    : AppConstants.textSecondaryColor,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppConstants.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                chat.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return AppConstants.primaryColor;
      case NotificationType.comment:
        return Colors.blue;
      case NotificationType.follow:
        return Colors.green;
      case NotificationType.mention:
        return Colors.orange;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.comment:
        return Icons.chat_bubble;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.mention:
        return Icons.alternate_email;
    }
  }
}

enum NotificationType { like, comment, follow, mention }

class NotificationItem {
  final NotificationType type;
  final String user;
  final String message;
  final String time;
  final bool isRead;

  NotificationItem({
    required this.type,
    required this.user,
    required this.message,
    required this.time,
    required this.isRead,
  });
}

class ChatItem {
  final String user;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  ChatItem({
    required this.user,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
  });
}