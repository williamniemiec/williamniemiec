import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'label.g.dart';

@JsonSerializable()
class ChatLabel {
  final String id;
  final String name;
  final String colorHex;
  final String? description;
  final DateTime createdAt;

  const ChatLabel({
    required this.id,
    required this.name,
    required this.colorHex,
    this.description,
    required this.createdAt,
  });

  factory ChatLabel.fromJson(Map<String, dynamic> json) =>
      _$ChatLabelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatLabelToJson(this);

  Color get color => Color(int.parse(colorHex.replaceFirst('#', '0xFF')));

  ChatLabel copyWith({
    String? id,
    String? name,
    String? colorHex,
    String? description,
    DateTime? createdAt,
  }) {
    return ChatLabel(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static List<ChatLabel> getDefaultLabels() {
    final now = DateTime.now();
    return [
      ChatLabel(
        id: 'new_customer',
        name: 'New Customer',
        colorHex: '#4CAF50',
        description: 'First-time customers',
        createdAt: now,
      ),
      ChatLabel(
        id: 'pending_payment',
        name: 'Pending Payment',
        colorHex: '#FF9800',
        description: 'Awaiting payment confirmation',
        createdAt: now,
      ),
      ChatLabel(
        id: 'paid',
        name: 'Paid',
        colorHex: '#2196F3',
        description: 'Payment confirmed',
        createdAt: now,
      ),
      ChatLabel(
        id: 'order_complete',
        name: 'Order Complete',
        colorHex: '#9C27B0',
        description: 'Order fulfilled and delivered',
        createdAt: now,
      ),
      ChatLabel(
        id: 'to_be_shipped',
        name: 'To Be Shipped',
        colorHex: '#FF5722',
        description: 'Ready for shipping',
        createdAt: now,
      ),
    ];
  }
}