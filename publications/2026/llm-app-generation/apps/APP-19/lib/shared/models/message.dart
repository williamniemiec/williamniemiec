enum MessageStatus {
  unread,
  read,
  archived,
}

enum MessagePriority {
  normal,
  urgent,
  high,
}

class MessageAttachment {
  final String id;
  final String fileName;
  final String fileType;
  final int fileSize;
  final String? thumbnailUrl;
  final String downloadUrl;

  MessageAttachment({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    this.thumbnailUrl,
    required this.downloadUrl,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'] ?? '',
      fileName: json['fileName'] ?? '',
      fileType: json['fileType'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      thumbnailUrl: json['thumbnailUrl'],
      downloadUrl: json['downloadUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
      'thumbnailUrl': thumbnailUrl,
      'downloadUrl': downloadUrl,
    };
  }
}

class Message {
  final String id;
  final String threadId;
  final String senderId;
  final String senderName;
  final String senderRole; // 'patient', 'doctor', 'nurse', 'admin'
  final String recipientId;
  final String subject;
  final String content;
  final DateTime sentAt;
  final MessageStatus status;
  final MessagePriority priority;
  final List<MessageAttachment> attachments;
  final String? replyToId;
  final bool isFromProvider;

  Message({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.recipientId,
    required this.subject,
    required this.content,
    required this.sentAt,
    this.status = MessageStatus.unread,
    this.priority = MessagePriority.normal,
    this.attachments = const [],
    this.replyToId,
    this.isFromProvider = false,
  });

  bool get isUnread => status == MessageStatus.unread;
  bool get isUrgent => priority == MessagePriority.urgent;
  bool get hasAttachments => attachments.isNotEmpty;

  String get priorityDisplayName {
    switch (priority) {
      case MessagePriority.normal:
        return 'Normal';
      case MessagePriority.urgent:
        return 'Urgent';
      case MessagePriority.high:
        return 'High';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case MessageStatus.unread:
        return 'Unread';
      case MessageStatus.read:
        return 'Read';
      case MessageStatus.archived:
        return 'Archived';
    }
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      threadId: json['threadId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderRole: json['senderRole'] ?? '',
      recipientId: json['recipientId'] ?? '',
      subject: json['subject'] ?? '',
      content: json['content'] ?? '',
      sentAt: DateTime.parse(json['sentAt']),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.unread,
      ),
      priority: MessagePriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => MessagePriority.normal,
      ),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => MessageAttachment.fromJson(e))
          .toList() ?? [],
      replyToId: json['replyToId'],
      isFromProvider: json['isFromProvider'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'threadId': threadId,
      'senderId': senderId,
      'senderName': senderName,
      'senderRole': senderRole,
      'recipientId': recipientId,
      'subject': subject,
      'content': content,
      'sentAt': sentAt.toIso8601String(),
      'status': status.name,
      'priority': priority.name,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'replyToId': replyToId,
      'isFromProvider': isFromProvider,
    };
  }

  Message copyWith({
    String? id,
    String? threadId,
    String? senderId,
    String? senderName,
    String? senderRole,
    String? recipientId,
    String? subject,
    String? content,
    DateTime? sentAt,
    MessageStatus? status,
    MessagePriority? priority,
    List<MessageAttachment>? attachments,
    String? replyToId,
    bool? isFromProvider,
  }) {
    return Message(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderRole: senderRole ?? this.senderRole,
      recipientId: recipientId ?? this.recipientId,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      attachments: attachments ?? this.attachments,
      replyToId: replyToId ?? this.replyToId,
      isFromProvider: isFromProvider ?? this.isFromProvider,
    );
  }
}