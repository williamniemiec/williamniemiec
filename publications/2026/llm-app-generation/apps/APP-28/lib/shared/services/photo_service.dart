import 'dart:math';
import '../models/photo.dart';
import '../../core/constants/app_constants.dart';

class PhotoService {
  static final PhotoService _instance = PhotoService._internal();
  factory PhotoService() => _instance;
  PhotoService._internal();

  final List<Photo> _photos = [];

  Future<List<Photo>> getAllPhotos() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_photos.isEmpty) {
      _generateSamplePhotos();
    }
    
    return List.from(_photos);
  }

  Future<Photo> getPhotoById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _photos.firstWhere((photo) => photo.id == id);
  }

  Future<void> addPhoto(Photo photo) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _photos.add(photo);
  }

  Future<void> updatePhoto(Photo photo) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _photos.indexWhere((p) => p.id == photo.id);
    if (index != -1) {
      _photos[index] = photo;
    }
  }

  Future<void> deletePhoto(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _photos.removeWhere((photo) => photo.id == id);
  }

  Future<List<Photo>> searchPhotos(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) return _photos;
    
    final lowercaseQuery = query.toLowerCase();
    return _photos.where((photo) {
      return photo.name.toLowerCase().contains(lowercaseQuery) ||
             photo.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)) ||
             (photo.location?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  Future<List<Photo>> getPhotosByLocation(String location) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _photos.where((photo) => 
      photo.location?.toLowerCase().contains(location.toLowerCase()) ?? false
    ).toList();
  }

  Future<List<Photo>> getPhotosByDateRange(DateTime start, DateTime end) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _photos.where((photo) => 
      photo.dateCreated.isAfter(start) && photo.dateCreated.isBefore(end)
    ).toList();
  }

  Future<List<Photo>> getFavoritePhotos() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _photos.where((photo) => photo.isFavorite).toList();
  }

  void _generateSamplePhotos() {
    final random = Random();
    final now = DateTime.now();
    
    final sampleData = [
      {'name': 'Beach Sunset', 'location': 'Malibu Beach', 'tags': ['sunset', 'beach', 'ocean']},
      {'name': 'Mountain View', 'location': 'Rocky Mountains', 'tags': ['mountain', 'landscape', 'nature']},
      {'name': 'City Lights', 'location': 'New York City', 'tags': ['city', 'night', 'lights']},
      {'name': 'Forest Path', 'location': 'Yellowstone Park', 'tags': ['forest', 'path', 'trees']},
      {'name': 'Lake Reflection', 'location': 'Lake Tahoe', 'tags': ['lake', 'reflection', 'water']},
      {'name': 'Desert Dunes', 'location': 'Sahara Desert', 'tags': ['desert', 'sand', 'dunes']},
      {'name': 'Snowy Peaks', 'location': 'Swiss Alps', 'tags': ['snow', 'mountains', 'winter']},
      {'name': 'Tropical Paradise', 'location': 'Hawaii', 'tags': ['tropical', 'palm', 'beach']},
      {'name': 'Urban Architecture', 'location': 'Tokyo', 'tags': ['architecture', 'building', 'modern']},
      {'name': 'Countryside', 'location': 'Tuscany', 'tags': ['countryside', 'hills', 'green']},
      {'name': 'Waterfall', 'location': 'Niagara Falls', 'tags': ['waterfall', 'water', 'nature']},
      {'name': 'Cherry Blossoms', 'location': 'Kyoto', 'tags': ['flowers', 'spring', 'pink']},
      {'name': 'Northern Lights', 'location': 'Iceland', 'tags': ['aurora', 'night', 'sky']},
      {'name': 'Canyon View', 'location': 'Grand Canyon', 'tags': ['canyon', 'rock', 'landscape']},
      {'name': 'Ocean Waves', 'location': 'Pacific Coast', 'tags': ['ocean', 'waves', 'blue']},
      {'name': 'Autumn Leaves', 'location': 'Vermont', 'tags': ['autumn', 'leaves', 'colorful']},
      {'name': 'Starry Night', 'location': 'Death Valley', 'tags': ['stars', 'night', 'sky']},
      {'name': 'Flower Garden', 'location': 'Netherlands', 'tags': ['flowers', 'garden', 'colorful']},
      {'name': 'Ice Cave', 'location': 'Alaska', 'tags': ['ice', 'cave', 'blue']},
      {'name': 'Sunrise', 'location': 'Santorini', 'tags': ['sunrise', 'morning', 'golden']},
    ];

    for (int i = 0; i < sampleData.length; i++) {
      final data = sampleData[i];
      final daysAgo = random.nextInt(365);
      final photo = Photo(
        id: 'photo_$i',
        path: 'assets/images/sample_${i + 1}.jpg',
        name: data['name'] as String,
        dateCreated: now.subtract(Duration(days: daysAgo)),
        size: random.nextInt(5000000) + 1000000, // 1-6MB
        width: 1920 + random.nextInt(1080),
        height: 1080 + random.nextInt(720),
        location: data['location'] as String,
        latitude: random.nextDouble() * 180 - 90,
        longitude: random.nextDouble() * 360 - 180,
        tags: List<String>.from(data['tags'] as List),
        isFavorite: random.nextBool(),
        type: random.nextBool() ? PhotoType.image : PhotoType.video,
      );
      _photos.add(photo);
    }

    // Sort by date (newest first)
    _photos.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
  }

  // Utility methods for photo editing
  Future<Photo> applyFilter(Photo photo, String filterName) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Simulate filter application
    final updatedPhoto = photo.copyWith(
      name: '${photo.name} ($filterName)',
      dateModified: DateTime.now(),
    );
    await updatePhoto(updatedPhoto);
    return updatedPhoto;
  }

  Future<Photo> cropPhoto(Photo photo, double aspectRatio) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate cropping
    final newHeight = (photo.width / aspectRatio).round();
    final updatedPhoto = photo.copyWith(
      height: newHeight,
      dateModified: DateTime.now(),
    );
    await updatePhoto(updatedPhoto);
    return updatedPhoto;
  }

  Future<Photo> adjustBrightness(Photo photo, double brightness) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Simulate brightness adjustment
    final updatedPhoto = photo.copyWith(
      dateModified: DateTime.now(),
    );
    await updatePhoto(updatedPhoto);
    return updatedPhoto;
  }

  Future<void> sharePhoto(Photo photo, List<String> recipients) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate sharing
  }

  Future<void> downloadPhoto(Photo photo, String destinationPath) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Simulate download
  }
}