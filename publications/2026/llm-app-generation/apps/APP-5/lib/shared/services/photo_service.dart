import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';

class PhotoService {
  static const _uuid = Uuid();
  final ImagePicker _picker = ImagePicker();

  // Pick image from camera
  Future<String?> pickFromCamera() async {
    try {
      // Request camera permission
      final cameraPermission = await Permission.camera.request();
      if (!cameraPermission.isGranted) {
        throw PhotoServiceException('Camera permission denied');
      }

      // Pick image from camera
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: (AppConstants.imageCompressionQuality * 100).toInt(),
        maxWidth: AppConstants.freeMaxResolution.toDouble(),
        maxHeight: AppConstants.freeMaxResolution.toDouble(),
      );

      if (image == null) return null;

      // Validate and save image
      return await _processAndSaveImage(image);
    } catch (e) {
      throw PhotoServiceException('Failed to capture photo: $e');
    }
  }

  // Pick image from gallery
  Future<String?> pickFromGallery() async {
    try {
      // Request storage permission (for older Android versions)
      if (Platform.isAndroid) {
        final storagePermission = await Permission.storage.request();
        if (!storagePermission.isGranted) {
          // Try photos permission for newer Android versions
          final photosPermission = await Permission.photos.request();
          if (!photosPermission.isGranted) {
            throw PhotoServiceException('Storage permission denied');
          }
        }
      }

      // Pick image from gallery
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: (AppConstants.imageCompressionQuality * 100).toInt(),
        maxWidth: AppConstants.freeMaxResolution.toDouble(),
        maxHeight: AppConstants.freeMaxResolution.toDouble(),
      );

      if (image == null) return null;

      // Validate and save image
      return await _processAndSaveImage(image);
    } catch (e) {
      throw PhotoServiceException('Failed to pick photo: $e');
    }
  }

  // Show image source selection dialog
  Future<String?> showImageSourceDialog(BuildContext context) async {
    return await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                const Text(
                  'Select Photo Source',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Camera option
                ListTile(
                  leading: const Icon(Icons.camera_alt, size: 32),
                  title: const Text('Camera'),
                  subtitle: const Text('Take a new photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    final imagePath = await pickFromCamera();
                    if (context.mounted && imagePath != null) {
                      Navigator.pop(context, imagePath);
                    }
                  },
                ),
                
                // Gallery option
                ListTile(
                  leading: const Icon(Icons.photo_library, size: 32),
                  title: const Text('Gallery'),
                  subtitle: const Text('Choose from gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    final imagePath = await pickFromGallery();
                    if (context.mounted && imagePath != null) {
                      Navigator.pop(context, imagePath);
                    }
                  },
                ),
                
                const SizedBox(height: 10),
                
                // Cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Process and save image
  Future<String> _processAndSaveImage(XFile image) async {
    // Validate image
    await _validateImage(image);

    // Get app directory
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${directory.path}/images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    // Generate unique filename
    final extension = image.path.split('.').last.toLowerCase();
    final fileName = '${_uuid.v4()}.$extension';
    final savedPath = '${imagesDir.path}/$fileName';

    // Copy image to app directory
    final File imageFile = File(image.path);
    await imageFile.copy(savedPath);

    return savedPath;
  }

  // Validate image file
  Future<void> _validateImage(XFile image) async {
    // Check file size
    final fileSize = await image.length();
    if (fileSize > AppConstants.maxImageSize) {
      throw PhotoServiceException(
        'Image too large. Maximum size is ${AppConstants.maxImageSize ~/ (1024 * 1024)}MB',
      );
    }

    // Check file format
    final extension = image.path.split('.').last.toLowerCase();
    if (!AppConstants.supportedImageFormats.contains(extension)) {
      throw PhotoServiceException(
        'Unsupported image format. Supported formats: ${AppConstants.supportedImageFormats.join(', ')}',
      );
    }
  }

  // Check permissions
  Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  Future<bool> checkStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status.isGranted) return true;
      
      // Check photos permission for newer Android versions
      final photosStatus = await Permission.photos.status;
      return photosStatus.isGranted;
    }
    return true; // iOS handles permissions automatically
  }

  // Request permissions
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (status.isGranted) return true;
      
      // Try photos permission for newer Android versions
      status = await Permission.photos.request();
      return status.isGranted;
    }
    return true; // iOS handles permissions automatically
  }

  // Delete image file
  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }

  // Get image file size
  Future<int> getImageSize(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Check if image exists
  Future<bool> imageExists(String imagePath) async {
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}

// Custom exception for photo service errors
class PhotoServiceException implements Exception {
  final String message;
  final String? code;

  const PhotoServiceException(this.message, {this.code});

  @override
  String toString() => 'PhotoServiceException: $message';
}