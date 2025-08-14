import 'package:aegis_vault/models/item_type.dart';

class VaultItem {
  final String id;
  final ItemType type;
  final String name;
  final String encryptedContent;
  final DateTime createdAt;
  final DateTime updatedAt;

  VaultItem({
    required this.id,
    required this.type,
    required this.name,
    required this.encryptedContent,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'name': name,
      'encryptedContent': encryptedContent,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory VaultItem.fromMap(Map<String, dynamic> map) {
    return VaultItem(
      id: map['id'],
      type: ItemType.values[map['type']],
      name: map['name'],
      encryptedContent: map['encryptedContent'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}