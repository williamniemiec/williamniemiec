import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

enum MessageType {
  user,
  assistant,
  system,
}

enum FeatureType {
  chatAnalysis,
  profileRoast,
  bioGenerator,
  rizzGenerator,
  generalAdvice,
}

@JsonSerializable()
class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final FeatureType? featureType;
  final List<String>? imageUrls;
  final Map<String, dynamic>? metadata;
  final bool isLoading;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.featureType,
    this.imageUrls,
    this.metadata,
    this.isLoading = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    FeatureType? featureType,
    List<String>? imageUrls,
    Map<String, dynamic>? metadata,
    bool? isLoading,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      featureType: featureType ?? this.featureType,
      imageUrls: imageUrls ?? this.imageUrls,
      metadata: metadata ?? this.metadata,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  static ChatMessage createUserMessage({
    required String content,
    FeatureType? featureType,
    List<String>? imageUrls,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.user,
      timestamp: DateTime.now(),
      featureType: featureType,
      imageUrls: imageUrls,
      metadata: metadata,
    );
  }

  static ChatMessage createAssistantMessage({
    required String content,
    FeatureType? featureType,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.assistant,
      timestamp: DateTime.now(),
      featureType: featureType,
      metadata: metadata,
    );
  }

  static ChatMessage createLoadingMessage() {
    return ChatMessage(
      id: 'loading_${DateTime.now().millisecondsSinceEpoch}',
      content: '',
      type: MessageType.assistant,
      timestamp: DateTime.now(),
      isLoading: true,
    );
  }
}