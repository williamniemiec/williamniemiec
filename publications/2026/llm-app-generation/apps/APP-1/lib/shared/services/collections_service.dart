import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/playback_state.dart';
import '../models/audiobook.dart';

class CollectionsService extends StateNotifier<List<Collection>> {
  late Box<Map> _collectionsBox;
  
  CollectionsService() : super([]) {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    try {
      _collectionsBox = await Hive.openBox<Map>('collections');
      _loadCollections();
    } catch (e) {
      print('Error initializing collections service: $e');
    }
  }

  void _loadCollections() {
    final collections = <Collection>[];
    
    for (final key in _collectionsBox.keys) {
      final data = _collectionsBox.get(key);
      if (data != null) {
        collections.add(Collection(
          id: data['id'] ?? key,
          name: data['name'] ?? 'Untitled Collection',
          description: data['description'],
          itemIds: List<String>.from(data['itemIds'] ?? []),
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] ?? 0),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updatedAt'] ?? 0),
          coverImageUrl: data['coverImageUrl'],
        ));
      }
    }
    
    // Sort by updated date (most recent first)
    collections.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    state = collections;
  }

  Future<void> _saveCollection(Collection collection) async {
    await _collectionsBox.put(collection.id, {
      'id': collection.id,
      'name': collection.name,
      'description': collection.description,
      'itemIds': collection.itemIds,
      'createdAt': collection.createdAt.millisecondsSinceEpoch,
      'updatedAt': collection.updatedAt.millisecondsSinceEpoch,
      'coverImageUrl': collection.coverImageUrl,
    });
  }

  Future<void> createCollection(String name, {String? description}) async {
    final now = DateTime.now();
    final collection = Collection(
      id: 'collection_${now.millisecondsSinceEpoch}',
      name: name,
      description: description,
      itemIds: [],
      createdAt: now,
      updatedAt: now,
    );
    
    state = [collection, ...state];
    await _saveCollection(collection);
  }

  Future<void> updateCollection(String id, {String? name, String? description}) async {
    final index = state.indexWhere((c) => c.id == id);
    if (index != -1) {
      final updatedCollection = state[index].copyWith(
        name: name ?? state[index].name,
        description: description ?? state[index].description,
        updatedAt: DateTime.now(),
      );
      
      final newState = List<Collection>.from(state);
      newState[index] = updatedCollection;
      state = newState;
      
      await _saveCollection(updatedCollection);
    }
  }

  Future<void> deleteCollection(String id) async {
    state = state.where((c) => c.id != id).toList();
    await _collectionsBox.delete(id);
  }

  Future<void> addItemToCollection(String collectionId, String itemId) async {
    final index = state.indexWhere((c) => c.id == collectionId);
    if (index != -1 && !state[index].itemIds.contains(itemId)) {
      final updatedCollection = state[index].copyWith(
        itemIds: [...state[index].itemIds, itemId],
        updatedAt: DateTime.now(),
      );
      
      final newState = List<Collection>.from(state);
      newState[index] = updatedCollection;
      state = newState;
      
      await _saveCollection(updatedCollection);
    }
  }

  Future<void> removeItemFromCollection(String collectionId, String itemId) async {
    final index = state.indexWhere((c) => c.id == collectionId);
    if (index != -1) {
      final updatedItemIds = state[index].itemIds.where((id) => id != itemId).toList();
      final updatedCollection = state[index].copyWith(
        itemIds: updatedItemIds,
        updatedAt: DateTime.now(),
      );
      
      final newState = List<Collection>.from(state);
      newState[index] = updatedCollection;
      state = newState;
      
      await _saveCollection(updatedCollection);
    }
  }

  Collection? getCollection(String id) {
    return state.firstWhere((c) => c.id == id, orElse: () => throw StateError('Collection not found'));
  }

  List<Collection> getCollectionsContaining(String itemId) {
    return state.where((c) => c.itemIds.contains(itemId)).toList();
  }
}

class WishlistService extends StateNotifier<List<String>> {
  late Box<List> _wishlistBox;
  
  WishlistService() : super([]) {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    try {
      _wishlistBox = await Hive.openBox<List>('wishlist');
      _loadWishlist();
    } catch (e) {
      print('Error initializing wishlist service: $e');
    }
  }

  void _loadWishlist() {
    final wishlist = _wishlistBox.get('items', defaultValue: <String>[]);
    state = List<String>.from(wishlist ?? []);
  }

  Future<void> _saveWishlist() async {
    await _wishlistBox.put('items', state);
  }

  Future<void> addToWishlist(String itemId) async {
    if (!state.contains(itemId)) {
      state = [...state, itemId];
      await _saveWishlist();
    }
  }

  Future<void> removeFromWishlist(String itemId) async {
    state = state.where((id) => id != itemId).toList();
    await _saveWishlist();
  }

  bool isInWishlist(String itemId) {
    return state.contains(itemId);
  }

  Future<void> clearWishlist() async {
    state = [];
    await _saveWishlist();
  }
}

// Providers
final collectionsServiceProvider = StateNotifierProvider<CollectionsService, List<Collection>>((ref) {
  return CollectionsService();
});

final wishlistServiceProvider = StateNotifierProvider<WishlistService, List<String>>((ref) {
  return WishlistService();
});

// Convenience providers
final wishlistCountProvider = Provider<int>((ref) {
  return ref.watch(wishlistServiceProvider).length;
});

final collectionsCountProvider = Provider<int>((ref) {
  return ref.watch(collectionsServiceProvider).length;
});

// Helper functions
String getCollectionDisplayName(Collection collection) {
  if (collection.name.isEmpty) {
    return 'Untitled Collection';
  }
  return collection.name;
}

String getCollectionSubtitle(Collection collection) {
  final count = collection.itemCount;
  if (count == 0) {
    return 'Empty collection';
  } else if (count == 1) {
    return '1 item';
  } else {
    return '$count items';
  }
}

IconData getCollectionIcon(Collection collection) {
  if (collection.itemIds.isEmpty) {
    return Icons.folder_outlined;
  }
  return Icons.folder;
}

Color getCollectionColor(Collection collection, BuildContext context) {
  if (collection.itemIds.isEmpty) {
    return Theme.of(context).disabledColor;
  }
  return Theme.of(context).primaryColor;
}