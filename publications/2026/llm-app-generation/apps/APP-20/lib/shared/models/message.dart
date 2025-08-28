class Message {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String type;
  final String priority;
  final String sender;
  final String? senderInstitution;
  final DateTime sentDate;
  final DateTime? readDate;
  final bool isRead;
  final bool isImportant;
  final String? actionUrl;
  final String? actionText;
  final List<MessageAttachment>? attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.type,
    required this.priority,
    required this.sender,
    this.senderInstitution,
    required this.sentDate,
    this.readDate,
    this.isRead = false,
    this.isImportant = false,
    this.actionUrl,
    this.actionText,
    this.attachments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      priority: json['priority'] as String,
      sender: json['sender'] as String,
      senderInstitution: json['senderInstitution'] as String?,
      sentDate: DateTime.parse(json['sentDate'] as String),
      readDate: json['readDate'] != null
          ? DateTime.parse(json['readDate'] as String)
          : null,
      isRead: json['isRead'] as bool? ?? false,
      isImportant: json['isImportant'] as bool? ?? false,
      actionUrl: json['actionUrl'] as String?,
      actionText: json['actionText'] as String?,
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((a) => MessageAttachment.fromJson(a as Map<String, dynamic>))
              .toList()
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'type': type,
      'priority': priority,
      'sender': sender,
      'senderInstitution': senderInstitution,
      'sentDate': sentDate.toIso8601String(),
      'readDate': readDate?.toIso8601String(),
      'isRead': isRead,
      'isImportant': isImportant,
      'actionUrl': actionUrl,
      'actionText': actionText,
      'attachments': attachments?.map((a) => a.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get typeDescription {
    switch (type.toLowerCase()) {
      case 'appointment':
      case 'consulta':
        return 'Consulta';
      case 'exam':
      case 'exame':
        return 'Exame';
      case 'vaccination':
      case 'vacinacao':
        return 'Vacinação';
      case 'medication':
      case 'medicamento':
        return 'Medicamento';
      case 'system':
      case 'sistema':
        return 'Sistema';
      case 'health_alert':
      case 'alerta_saude':
        return 'Alerta de Saúde';
      case 'campaign':
      case 'campanha':
        return 'Campanha';
      case 'notification':
      case 'notificacao':
        return 'Notificação';
      default:
        return type;
    }
  }

  String get priorityDescription {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'alta':
        return 'Alta';
      case 'medium':
      case 'media':
        return 'Média';
      case 'low':
      case 'baixa':
        return 'Baixa';
      case 'urgent':
      case 'urgente':
        return 'Urgente';
      default:
        return priority;
    }
  }

  bool get isHighPriority {
    return priority.toLowerCase() == 'high' || 
           priority.toLowerCase() == 'alta' ||
           priority.toLowerCase() == 'urgent' ||
           priority.toLowerCase() == 'urgente';
  }

  bool get isUrgent {
    return priority.toLowerCase() == 'urgent' ||
           priority.toLowerCase() == 'urgente';
  }

  String get formattedSentDate {
    return '${sentDate.day.toString().padLeft(2, '0')}/'
           '${sentDate.month.toString().padLeft(2, '0')}/'
           '${sentDate.year}';
  }

  String get formattedSentTime {
    return '${sentDate.hour.toString().padLeft(2, '0')}:'
           '${sentDate.minute.toString().padLeft(2, '0')}';
  }

  String get formattedSentDateTime {
    return '$formattedSentDate às $formattedSentTime';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(sentDate);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) return 'Há 1 dia';
      return 'Há ${difference.inDays} dias';
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) return 'Há 1 hora';
      return 'Há ${difference.inHours} horas';
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) return 'Há 1 minuto';
      return 'Há ${difference.inMinutes} minutos';
    } else {
      return 'Agora';
    }
  }

  bool get hasAttachments {
    return attachments != null && attachments!.isNotEmpty;
  }

  bool get hasAction {
    return actionUrl != null && actionUrl!.isNotEmpty;
  }

  String get preview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  Message copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? type,
    String? priority,
    String? sender,
    String? senderInstitution,
    DateTime? sentDate,
    DateTime? readDate,
    bool? isRead,
    bool? isImportant,
    String? actionUrl,
    String? actionText,
    List<MessageAttachment>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      sender: sender ?? this.sender,
      senderInstitution: senderInstitution ?? this.senderInstitution,
      sentDate: sentDate ?? this.sentDate,
      readDate: readDate ?? this.readDate,
      isRead: isRead ?? this.isRead,
      isImportant: isImportant ?? this.isImportant,
      actionUrl: actionUrl ?? this.actionUrl,
      actionText: actionText ?? this.actionText,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Message markAsRead() {
    return copyWith(
      isRead: true,
      readDate: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, title: $title, type: $type, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class MessageAttachment {
  final String id;
  final String messageId;
  final String fileName;
  final String fileType;
  final int fileSize;
  final String downloadUrl;
  final DateTime createdAt;

  MessageAttachment({
    required this.id,
    required this.messageId,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.downloadUrl,
    required this.createdAt,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'] as String,
      messageId: json['messageId'] as String,
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
      fileSize: json['fileSize'] as int,
      downloadUrl: json['downloadUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messageId': messageId,
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
      'downloadUrl': downloadUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get formattedFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  bool get isPdf {
    return fileType.toLowerCase() == 'pdf' || fileName.toLowerCase().endsWith('.pdf');
  }

  bool get isImage {
    final imageTypes = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageTypes.any((type) => 
      fileType.toLowerCase() == type || 
      fileName.toLowerCase().endsWith('.$type')
    );
  }

  bool get isDocument {
    final docTypes = ['doc', 'docx', 'txt', 'rtf'];
    return docTypes.any((type) => 
      fileType.toLowerCase() == type || 
      fileName.toLowerCase().endsWith('.$type')
    );
  }

  @override
  String toString() {
    return 'MessageAttachment(fileName: $fileName, fileType: $fileType, fileSize: $formattedFileSize)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageAttachment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}