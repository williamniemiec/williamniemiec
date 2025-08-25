// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
  id: json['id'] as String,
  contactId: json['contactId'] as String,
  contactName: json['contactName'] as String,
  contactPhone: json['contactPhone'] as String?,
  contactAvatar: json['contactAvatar'] as String?,
  lastMessage: json['lastMessage'] as String?,
  lastMessageTime: json['lastMessageTime'] == null
      ? null
      : DateTime.parse(json['lastMessageTime'] as String),
  unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
  labels:
      (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isArchived: json['isArchived'] as bool? ?? false,
  isPinned: json['isPinned'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
  'id': instance.id,
  'contactId': instance.contactId,
  'contactName': instance.contactName,
  'contactPhone': instance.contactPhone,
  'contactAvatar': instance.contactAvatar,
  'lastMessage': instance.lastMessage,
  'lastMessageTime': instance.lastMessageTime?.toIso8601String(),
  'unreadCount': instance.unreadCount,
  'labels': instance.labels,
  'isArchived': instance.isArchived,
  'isPinned': instance.isPinned,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  id: json['id'] as String,
  chatId: json['chatId'] as String,
  senderId: json['senderId'] as String,
  senderName: json['senderName'] as String?,
  content: json['content'] as String,
  type: $enumDecode(_$MessageTypeEnumMap, json['type']),
  status: $enumDecode(_$MessageStatusEnumMap, json['status']),
  timestamp: DateTime.parse(json['timestamp'] as String),
  mediaUrl: json['mediaUrl'] as String?,
  mediaFileName: json['mediaFileName'] as String?,
  mediaDuration: (json['mediaDuration'] as num?)?.toInt(),
  replyToMessageId: json['replyToMessageId'] as String?,
  isFromBusiness: json['isFromBusiness'] as bool? ?? false,
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'id': instance.id,
  'chatId': instance.chatId,
  'senderId': instance.senderId,
  'senderName': instance.senderName,
  'content': instance.content,
  'type': _$MessageTypeEnumMap[instance.type]!,
  'status': _$MessageStatusEnumMap[instance.status]!,
  'timestamp': instance.timestamp.toIso8601String(),
  'mediaUrl': instance.mediaUrl,
  'mediaFileName': instance.mediaFileName,
  'mediaDuration': instance.mediaDuration,
  'replyToMessageId': instance.replyToMessageId,
  'isFromBusiness': instance.isFromBusiness,
};

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.video: 'video',
  MessageType.audio: 'audio',
  MessageType.document: 'document',
  MessageType.location: 'location',
  MessageType.contact: 'contact',
  MessageType.catalog: 'catalog',
  MessageType.system: 'system',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
};
