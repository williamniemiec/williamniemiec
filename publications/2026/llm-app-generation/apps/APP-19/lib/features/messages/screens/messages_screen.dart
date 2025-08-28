import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/message.dart';
import '../providers/message_provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessageProvider>(context, listen: false).loadMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showComposeMessageDialog();
            },
          ),
        ],
      ),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          if (messageProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (messageProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    messageProvider.errorMessage!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      messageProvider.loadMessages();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (messageProvider.messages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message_outlined,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a conversation with your care team',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _showComposeMessageDialog,
                    child: const Text('Send Message'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => messageProvider.loadMessages(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messageProvider.messages.length,
              itemBuilder: (context, index) {
                final message = messageProvider.messages[index];
                return _MessageCard(
                  message: message,
                  onTap: () => _openMessage(message),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showComposeMessageDialog() {
    final subjectController = TextEditingController();
    final contentController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Message'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'To',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'dr1',
                    child: Text('Dr. Sarah Johnson - Cardiology'),
                  ),
                  DropdownMenuItem(
                    value: 'nurse1',
                    child: Text('Nurse Jennifer Smith'),
                  ),
                  DropdownMenuItem(
                    value: 'admin1',
                    child: Text('Patient Services'),
                  ),
                ],
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a recipient';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  prefixIcon: Icon(Icons.subject),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  prefixIcon: Icon(Icons.message_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Consumer<MessageProvider>(
            builder: (context, messageProvider, child) {
              return ElevatedButton(
                onPressed: messageProvider.isLoading
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          final success = await messageProvider.sendMessage(
                            subjectController.text,
                            contentController.text,
                            'dr1', // In a real app, this would be the selected recipient
                          );
                          
                          if (success && mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Message sent successfully'),
                              ),
                            );
                          }
                        }
                      },
                child: messageProvider.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openMessage(Message message) {
    // Mark as read
    Provider.of<MessageProvider>(context, listen: false).markAsRead(message.id);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.subject,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'From ${message.senderName} • ${DateFormat('MMM dd, yyyy \'at\' h:mm a').format(message.sentAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.priority == MessagePriority.urgent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.messageUrgent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.messageUrgent.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.priority_high,
                        size: 16,
                        color: AppColors.messageUrgent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Urgent',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.messageUrgent,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                message.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (message.attachments.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Attachments',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...message.attachments.map((attachment) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.attach_file,
                    color: AppColors.primary,
                  ),
                  title: Text(attachment.fileName),
                  subtitle: Text('${(attachment.fileSize / 1024).toStringAsFixed(1)} KB'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Download feature coming soon!'),
                        ),
                      );
                    },
                  ),
                )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reply feature coming soon!'),
                ),
              );
            },
            child: const Text('Reply'),
          ),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final Message message;
  final VoidCallback onTap;

  const _MessageCard({
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Unread indicator
              if (message.isUnread)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: const BoxDecoration(
                    color: AppColors.messageUnread,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(width: 20),
              
              // Message content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            message.subject,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: message.isUnread ? FontWeight.w600 : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (message.priority == MessagePriority.urgent)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.messageUrgent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'URGENT',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.messageUrgent,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'From ${message.senderName}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: message.isUnread ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.content,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Date and attachments
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('MMM dd').format(message.sentAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: message.isUnread ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  if (message.hasAttachments) ...[
                    const SizedBox(height: 4),
                    Icon(
                      Icons.attach_file,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}