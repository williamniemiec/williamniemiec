import 'dart:math';
import '../models/album.dart';
import '../models/photo.dart';

class AlbumService {
  static final AlbumService _instance = AlbumService._internal();
  factory AlbumService() => _instance;
  AlbumService._internal();

  final List<Album> _albums = [];
  final List<Memory> _memories = [];

  Future<List<Album>> getAllAlbums() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_albums.isEmpty) {
      _generateSampleAlbums();
    }
    
    return List.from(_albums);
  }

  Future<Album> getAlbumById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _albums.firstWhere((album) => album.id == id);
  }

  Future<void> createAlbum(Album album) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _albums.add(album);
  }

  Future<void> updateAlbum(Album album) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _albums.indexWhere((a) => a.id == album.id);
    if (index != -1) {
      _albums[index] = album;
    }
  }

  Future<void> deleteAlbum(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _albums.removeWhere((album) => album.id == id);
  }

  Future<List<Album>> getSharedAlbums() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _albums.where((album) => album.isShared).toList();
  }

  Future<List<Album>> getSystemAlbums() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _albums.where((album) => album.isSystemAlbum).toList();
  }

  Future<List<Album>> getUserAlbums() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _albums.where((album) => !album.isSystemAlbum).toList();
  }

  Future<void> addPhotoToAlbum(String photoId, String albumId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final album = _albums.firstWhere((a) => a.id == albumId);
    if (!album.photoIds.contains(photoId)) {
      final updatedPhotoIds = [...album.photoIds, photoId];
      final updatedAlbum = album.copyWith(
        photoIds: updatedPhotoIds,
        dateModified: DateTime.now(),
      );
      await updateAlbum(updatedAlbum);
    }
  }

  Future<void> removePhotoFromAlbum(String photoId, String albumId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final album = _albums.firstWhere((a) => a.id == albumId);
    final updatedPhotoIds = album.photoIds.where((id) => id != photoId).toList();
    final updatedAlbum = album.copyWith(
      photoIds: updatedPhotoIds,
      dateModified: DateTime.now(),
    );
    await updateAlbum(updatedAlbum);
  }

  Future<void> shareAlbum(String albumId, List<String> recipients) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final album = _albums.firstWhere((a) => a.id == albumId);
    final updatedAlbum = album.copyWith(
      isShared: true,
      sharedWith: [...album.sharedWith, ...recipients],
      dateModified: DateTime.now(),
    );
    await updateAlbum(updatedAlbum);
  }

  Future<void> unshareAlbum(String albumId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final album = _albums.firstWhere((a) => a.id == albumId);
    final updatedAlbum = album.copyWith(
      isShared: false,
      sharedWith: [],
      dateModified: DateTime.now(),
    );
    await updateAlbum(updatedAlbum);
  }

  // Memory operations
  Future<List<Memory>> getMemories() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    if (_memories.isEmpty) {
      _generateSampleMemories();
    }
    
    return List.from(_memories);
  }

  Future<Memory> getMemoryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _memories.firstWhere((memory) => memory.id == id);
  }

  Future<void> createMemory(Memory memory) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _memories.add(memory);
  }

  void _generateSampleAlbums() {
    final now = DateTime.now();
    final random = Random();

    // System albums
    final systemAlbums = [
      Album(
        id: 'favorites',
        name: 'Favorites',
        type: AlbumType.favorites,
        isSystemAlbum: true,
        photoIds: ['photo_0', 'photo_2', 'photo_5', 'photo_8'],
        coverPhotoId: 'photo_0',
      ),
      Album(
        id: 'screenshots',
        name: 'Screenshots',
        type: AlbumType.screenshots,
        isSystemAlbum: true,
        photoIds: ['photo_1', 'photo_3'],
        coverPhotoId: 'photo_1',
      ),
      Album(
        id: 'camera',
        name: 'Camera',
        type: AlbumType.camera,
        isSystemAlbum: true,
        photoIds: ['photo_4', 'photo_6', 'photo_7', 'photo_9', 'photo_10'],
        coverPhotoId: 'photo_4',
      ),
      Album(
        id: 'downloads',
        name: 'Downloads',
        type: AlbumType.downloads,
        isSystemAlbum: true,
        photoIds: ['photo_11', 'photo_12'],
        coverPhotoId: 'photo_11',
      ),
    ];

    // User albums
    final userAlbums = [
      Album(
        id: 'vacation_2024',
        name: 'Summer Vacation 2024',
        description: 'Amazing trip to the mountains and beaches',
        dateCreated: now.subtract(const Duration(days: 30)),
        photoIds: ['photo_0', 'photo_4', 'photo_7', 'photo_19'],
        coverPhotoId: 'photo_0',
        isShared: true,
        sharedWith: ['friend1@gmail.com', 'family@gmail.com'],
      ),
      Album(
        id: 'family_moments',
        name: 'Family Moments',
        description: 'Precious memories with family',
        dateCreated: now.subtract(const Duration(days: 60)),
        photoIds: ['photo_1', 'photo_3', 'photo_8', 'photo_15'],
        coverPhotoId: 'photo_1',
      ),
      Album(
        id: 'nature_photography',
        name: 'Nature Photography',
        description: 'Beautiful landscapes and wildlife',
        dateCreated: now.subtract(const Duration(days: 90)),
        photoIds: ['photo_2', 'photo_5', 'photo_9', 'photo_13', 'photo_16'],
        coverPhotoId: 'photo_2',
        isShared: true,
        sharedWith: ['photographer@gmail.com'],
      ),
      Album(
        id: 'city_adventures',
        name: 'City Adventures',
        description: 'Urban exploration and city life',
        dateCreated: now.subtract(const Duration(days: 45)),
        photoIds: ['photo_6', 'photo_10', 'photo_14', 'photo_17'],
        coverPhotoId: 'photo_6',
      ),
      Album(
        id: 'food_diary',
        name: 'Food Diary',
        description: 'Delicious meals and culinary adventures',
        dateCreated: now.subtract(const Duration(days: 15)),
        photoIds: ['photo_11', 'photo_18'],
        coverPhotoId: 'photo_11',
      ),
    ];

    _albums.addAll(systemAlbums);
    _albums.addAll(userAlbums);
  }

  void _generateSampleMemories() {
    final now = DateTime.now();
    final random = Random();

    final sampleMemories = [
      Memory(
        id: 'memory_1',
        title: 'A Year Ago Today',
        description: 'Beautiful moments from last year',
        date: now.subtract(const Duration(days: 365)),
        photoIds: ['photo_0', 'photo_1', 'photo_2'],
        coverPhotoId: 'photo_0',
        type: MemoryType.yearAgo,
      ),
      Memory(
        id: 'memory_2',
        title: 'Summer Trip',
        description: 'Your amazing summer adventure',
        date: now.subtract(const Duration(days: 90)),
        photoIds: ['photo_3', 'photo_4', 'photo_5', 'photo_6'],
        coverPhotoId: 'photo_3',
        type: MemoryType.trip,
      ),
      Memory(
        id: 'memory_3',
        title: 'Family Gathering',
        description: 'Special moments with loved ones',
        date: now.subtract(const Duration(days: 30)),
        photoIds: ['photo_7', 'photo_8', 'photo_9'],
        coverPhotoId: 'photo_7',
        type: MemoryType.people,
      ),
      Memory(
        id: 'memory_4',
        title: 'Nature Walks',
        description: 'Peaceful moments in nature',
        date: now.subtract(const Duration(days: 60)),
        photoIds: ['photo_10', 'photo_11', 'photo_12', 'photo_13'],
        coverPhotoId: 'photo_10',
        type: MemoryType.general,
      ),
      Memory(
        id: 'memory_5',
        title: 'City Lights',
        description: 'Urban photography collection',
        date: now.subtract(const Duration(days: 45)),
        photoIds: ['photo_14', 'photo_15', 'photo_16'],
        coverPhotoId: 'photo_14',
        type: MemoryType.general,
      ),
    ];

    _memories.addAll(sampleMemories);
  }

  // Search operations
  Future<List<Album>> searchAlbums(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (query.isEmpty) return _albums;
    
    final lowercaseQuery = query.toLowerCase();
    return _albums.where((album) {
      return album.name.toLowerCase().contains(lowercaseQuery) ||
             (album.description?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }
}