import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final ImagePicker _picker = ImagePicker();

  Future<List<String>> pickImagesFromGallery({int maxImages = 5}) async {
    try {
      // Request permission
      final permission = await _requestGalleryPermission();
      if (!permission) {
        throw ImageServiceException('Gallery permission denied');
      }

      // Pick multiple images
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (images.isEmpty) {
        return [];
      }

      // Limit the number of images
      final limitedImages = images.take(maxImages).toList();
      
      // Convert to file paths
      final List<String> imagePaths = [];
      for (final image in limitedImages) {
        imagePaths.add(image.path);
      }

      debugPrint('Selected ${imagePaths.length} images from gallery');
      return imagePaths;
    } catch (e) {
      debugPrint('Error picking images from gallery: $e');
      throw ImageServiceException('Failed to pick images: ${e.toString()}');
    }
  }

  Future<String?> pickSingleImageFromGallery() async {
    try {
      // Request permission
      final permission = await _requestGalleryPermission();
      if (!permission) {
        throw ImageServiceException('Gallery permission denied');
      }

      // Pick single image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) {
        return null;
      }

      debugPrint('Selected image from gallery: ${image.path}');
      return image.path;
    } catch (e) {
      debugPrint('Error picking single image from gallery: $e');
      throw ImageServiceException('Failed to pick image: ${e.toString()}');
    }
  }

  Future<String?> takePhotoWithCamera() async {
    try {
      // Request permission
      final permission = await _requestCameraPermission();
      if (!permission) {
        throw ImageServiceException('Camera permission denied');
      }

      // Take photo
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) {
        return null;
      }

      debugPrint('Took photo with camera: ${image.path}');
      return image.path;
    } catch (e) {
      debugPrint('Error taking photo with camera: $e');
      throw ImageServiceException('Failed to take photo: ${e.toString()}');
    }
  }

  Future<bool> _requestGalleryPermission() async {
    try {
      if (Platform.isAndroid) {
        // For Android 13+ (API 33+), we need different permissions
        final androidInfo = await _getAndroidVersion();
        if (androidInfo >= 33) {
          final status = await Permission.photos.request();
          return status.isGranted;
        } else {
          final status = await Permission.storage.request();
          return status.isGranted;
        }
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        return status.isGranted;
      }
      return true; // For other platforms
    } catch (e) {
      debugPrint('Error requesting gallery permission: $e');
      return false;
    }
  }

  Future<bool> _requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('Error requesting camera permission: $e');
      return false;
    }
  }

  Future<int> _getAndroidVersion() async {
    // This is a simplified version. In a real app, you might use device_info_plus
    return 30; // Default to API 30
  }

  Future<Uint8List?> getImageBytes(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (!await file.exists()) {
        throw ImageServiceException('Image file not found: $imagePath');
      }

      final Uint8List bytes = await file.readAsBytes();
      debugPrint('Read ${bytes.length} bytes from image: $imagePath');
      return bytes;
    } catch (e) {
      debugPrint('Error reading image bytes: $e');
      throw ImageServiceException('Failed to read image: ${e.toString()}');
    }
  }

  Future<String> saveImageToAppDirectory(String sourcePath, {String? customName}) async {
    try {
      final File sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw ImageServiceException('Source image not found: $sourcePath');
      }

      // Create app directory for images
      final Directory appDir = Directory('/data/data/com.example.tea_app/files/images');
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }

      // Generate filename
      final String extension = path.extension(sourcePath);
      final String filename = customName ?? 'image_${DateTime.now().millisecondsSinceEpoch}$extension';
      final String destinationPath = path.join(appDir.path, filename);

      // Copy file
      final File destinationFile = await sourceFile.copy(destinationPath);
      
      debugPrint('Image saved to app directory: $destinationPath');
      return destinationFile.path;
    } catch (e) {
      debugPrint('Error saving image to app directory: $e');
      throw ImageServiceException('Failed to save image: ${e.toString()}');
    }
  }

  Future<bool> deleteImage(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Image deleted: $imagePath');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  Future<List<String>> compressImages(List<String> imagePaths, {int quality = 85}) async {
    try {
      final List<String> compressedPaths = [];
      
      for (final imagePath in imagePaths) {
        // For this demo, we'll just return the original paths
        // In a real app, you might use packages like flutter_image_compress
        compressedPaths.add(imagePath);
      }

      debugPrint('Compressed ${compressedPaths.length} images');
      return compressedPaths;
    } catch (e) {
      debugPrint('Error compressing images: $e');
      throw ImageServiceException('Failed to compress images: ${e.toString()}');
    }
  }

  String getImageFileName(String imagePath) {
    return path.basename(imagePath);
  }

  String getImageExtension(String imagePath) {
    return path.extension(imagePath);
  }

  Future<int> getImageFileSize(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (!await file.exists()) {
        return 0;
      }
      return await file.length();
    } catch (e) {
      debugPrint('Error getting image file size: $e');
      return 0;
    }
  }

  bool isValidImagePath(String imagePath) {
    final String extension = getImageExtension(imagePath).toLowerCase();
    const List<String> validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    return validExtensions.contains(extension);
  }

  Future<void> showImagePickerOptions({
    required Function(List<String>) onImagesSelected,
    required Function(String) onError,
    bool allowMultiple = true,
    bool showCamera = true,
  }) async {
    try {
      // This would typically show a bottom sheet or dialog
      // For now, we'll just pick from gallery
      if (allowMultiple) {
        final images = await pickImagesFromGallery();
        onImagesSelected(images);
      } else {
        final image = await pickSingleImageFromGallery();
        if (image != null) {
          onImagesSelected([image]);
        } else {
          onImagesSelected([]);
        }
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  // Mock upload function - in a real app, this would upload to a server
  Future<List<String>> uploadImages(List<String> imagePaths) async {
    try {
      // Simulate upload delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Return mock URLs
      final List<String> uploadedUrls = [];
      for (int i = 0; i < imagePaths.length; i++) {
        uploadedUrls.add('https://api.tea-app.com/images/uploaded_image_${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
      }
      
      debugPrint('Uploaded ${uploadedUrls.length} images');
      return uploadedUrls;
    } catch (e) {
      debugPrint('Error uploading images: $e');
      throw ImageServiceException('Failed to upload images: ${e.toString()}');
    }
  }

  Future<void> clearImageCache() async {
    try {
      final Directory appDir = Directory('/data/data/com.example.tea_app/files/images');
      if (await appDir.exists()) {
        await appDir.delete(recursive: true);
        debugPrint('Image cache cleared');
      }
    } catch (e) {
      debugPrint('Error clearing image cache: $e');
    }
  }
}

class ImageServiceException implements Exception {
  final String message;
  ImageServiceException(this.message);

  @override
  String toString() => 'ImageServiceException: $message';
}