import 'package:flutter/material.dart';
import '../../shared/models/photo.dart';
import '../../shared/models/album.dart';
import '../../shared/services/photo_service.dart';
import '../../shared/services/album_service.dart';

class AppProvider extends ChangeNotifier {
  final PhotoService _photoService = PhotoService();
  final AlbumService _albumService = AlbumService();

  List<Photo> _photos = [];
  List<Album> _albums = [];
  List<Memory> _memories = [];
  bool _isLoading = false;
  String? _error;
  int _gridCrossAxisCount = 3;

  // Getters
  List<Photo> get photos => _photos;
  List<Album> get albums => _albums;
  List<Memory> get memories => _memories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get gridCrossAxisCount => _gridCrossAxisCount;

  List<Photo> get favoritePhotos => _photos.where((photo) => photo.isFavorite).toList();
  List<Photo> get recentPhotos => _photos.where((photo) => !photo.isDeleted).toList()
    ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

  AppProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadPhotos();
    await loadAlbums();
    await loadMemories();
  }

  // Photo operations
  Future<void> loadPhotos() async {
    _setLoading(true);
    try {
      _photos = await _photoService.getAllPhotos();
      _clearError();
    } catch (e) {
      _setError('Failed to load photos: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addPhoto(Photo photo) async {
    try {
      await _photoService.addPhoto(photo);
      _photos.add(photo);
      notifyListeners();
    } catch (e) {
      _setError('Failed to add photo: $e');
    }
  }

  Future<void> updatePhoto(Photo photo) async {
    try {
      await _photoService.updatePhoto(photo);
      final index = _photos.indexWhere((p) => p.id == photo.id);
      if (index != -1) {
        _photos[index] = photo;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update photo: $e');
    }
  }

  Future<void> deletePhoto(String photoId) async {
    try {
      await _photoService.deletePhoto(photoId);
      _photos.removeWhere((photo) => photo.id == photoId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete photo: $e');
    }
  }

  Future<void> toggleFavorite(String photoId) async {
    final photo = _photos.firstWhere((p) => p.id == photoId);
    final updatedPhoto = photo.copyWith(isFavorite: !photo.isFavorite);
    await updatePhoto(updatedPhoto);
  }

  // Album operations
  Future<void> loadAlbums() async {
    try {
      _albums = await _albumService.getAllAlbums();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load albums: $e');
    }
  }

  Future<void> createAlbum(Album album) async {
    try {
      await _albumService.createAlbum(album);
      _albums.add(album);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create album: $e');
    }
  }

  Future<void> updateAlbum(Album album) async {
    try {
      await _albumService.updateAlbum(album);
      final index = _albums.indexWhere((a) => a.id == album.id);
      if (index != -1) {
        _albums[index] = album;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update album: $e');
    }
  }

  Future<void> deleteAlbum(String albumId) async {
    try {
      await _albumService.deleteAlbum(albumId);
      _albums.removeWhere((album) => album.id == albumId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete album: $e');
    }
  }

  Future<void> addPhotoToAlbum(String photoId, String albumId) async {
    try {
      final album = _albums.firstWhere((a) => a.id == albumId);
      final updatedPhotoIds = [...album.photoIds, photoId];
      final updatedAlbum = album.copyWith(photoIds: updatedPhotoIds);
      await updateAlbum(updatedAlbum);
    } catch (e) {
      _setError('Failed to add photo to album: $e');
    }
  }

  Future<void> removePhotoFromAlbum(String photoId, String albumId) async {
    try {
      final album = _albums.firstWhere((a) => a.id == albumId);
      final updatedPhotoIds = album.photoIds.where((id) => id != photoId).toList();
      final updatedAlbum = album.copyWith(photoIds: updatedPhotoIds);
      await updateAlbum(updatedAlbum);
    } catch (e) {
      _setError('Failed to remove photo from album: $e');
    }
  }

  // Memory operations
  Future<void> loadMemories() async {
    try {
      _memories = await _albumService.getMemories();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load memories: $e');
    }
  }

  // Search operations
  List<Photo> searchPhotos(String query) {
    if (query.isEmpty) return _photos;
    
    final lowercaseQuery = query.toLowerCase();
    return _photos.where((photo) {
      return photo.name.toLowerCase().contains(lowercaseQuery) ||
             photo.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)) ||
             (photo.location?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  List<Photo> getPhotosByLocation(String location) {
    return _photos.where((photo) => 
      photo.location?.toLowerCase().contains(location.toLowerCase()) ?? false
    ).toList();
  }

  List<Photo> getPhotosByDateRange(DateTime start, DateTime end) {
    return _photos.where((photo) => 
      photo.dateCreated.isAfter(start) && photo.dateCreated.isBefore(end)
    ).toList();
  }

  // Grid settings
  void updateGridCrossAxisCount(int count) {
    _gridCrossAxisCount = count.clamp(2, 5);
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  Photo? getPhotoById(String id) {
    try {
      return _photos.firstWhere((photo) => photo.id == id);
    } catch (e) {
      return null;
    }
  }

  Album? getAlbumById(String id) {
    try {
      return _albums.firstWhere((album) => album.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Photo> getPhotosForAlbum(String albumId) {
    final album = getAlbumById(albumId);
    if (album == null) return [];
    
    return album.photoIds
        .map((id) => getPhotoById(id))
        .where((photo) => photo != null)
        .cast<Photo>()
        .toList();
  }
}