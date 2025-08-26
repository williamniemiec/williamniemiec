import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../models/pin.dart';
import 'api_service.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      // Request permission
      final permission = await Permission.photos.request();
      if (!permission.isGranted) {
        throw Exception('Gallery permission denied');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  // Take photo with camera
  Future<File?> takePhoto() async {
    try {
      // Request permission
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        throw Exception('Camera permission denied');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  // Crop image
  Future<File?> cropImage(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: const Color(0xFFE60023), // Pinterest red
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            doneButtonTitle: 'Done',
            cancelButtonTitle: 'Cancel',
          ),
        ],
      );

      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      print('Error cropping image: $e');
      return null;
    }
  }

  // Get image dimensions
  Future<Map<String, int>?> getImageDimensions(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = await decodeImageFromList(bytes);
      
      return {
        'width': image.width,
        'height': image.height,
      };
    } catch (e) {
      print('Error getting image dimensions: $e');
      return null;
    }
  }

  // Visual search using ML Kit
  Future<List<Pin>> performVisualSearch(File imageFile) async {
    try {
      // First, upload the image to get a URL
      final imageUrl = await _apiService.uploadImage(imageFile);
      
      // Perform visual search using the API
      final results = await _apiService.visualSearch(imageUrl);
      
      return results;
    } catch (e) {
      print('Error performing visual search: $e');
      return [];
    }
  }

  // Extract text from image using ML Kit
  Future<List<String>> extractTextFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer();
      
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      final List<String> extractedTexts = [];
      for (TextBlock block in recognizedText.blocks) {
        extractedTexts.add(block.text);
      }
      
      await textRecognizer.close();
      return extractedTexts;
    } catch (e) {
      print('Error extracting text from image: $e');
      return [];
    }
  }

  // Detect objects in image using ML Kit
  Future<List<String>> detectObjectsInImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final objectDetector = ObjectDetector(
        options: ObjectDetectorOptions(
          mode: DetectionMode.single,
          classifyObjects: true,
          multipleObjects: true,
        ),
      );
      
      final List<DetectedObject> objects = await objectDetector.processImage(inputImage);
      
      final List<String> detectedObjects = [];
      for (DetectedObject detectedObject in objects) {
        for (Label label in detectedObject.labels) {
          detectedObjects.add(label.text);
        }
      }
      
      await objectDetector.close();
      return detectedObjects;
    } catch (e) {
      print('Error detecting objects in image: $e');
      return [];
    }
  }

  // Generate image tags using ML Kit
  Future<List<String>> generateImageTags(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final imageLabeler = ImageLabeler(
        options: ImageLabelerOptions(
          confidenceThreshold: 0.7,
        ),
      );
      
      final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
      
      final List<String> tags = [];
      for (ImageLabel label in labels) {
        tags.add(label.label.toLowerCase());
      }
      
      await imageLabeler.close();
      return tags;
    } catch (e) {
      print('Error generating image tags: $e');
      return [];
    }
  }

  // Compress image
  Future<File?> compressImage(File imageFile, {int quality = 85}) async {
    try {
      final bytes = await imageFile.readAsBytes();
      
      // Create a new file with compressed data
      final compressedFile = File('${imageFile.path}_compressed.jpg');
      
      // In a real implementation, you would use an image compression library
      // For now, we'll just copy the file
      await compressedFile.writeAsBytes(bytes);
      
      return compressedFile;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  // Resize image
  Future<File?> resizeImage(File imageFile, {int maxWidth = 1920, int maxHeight = 1920}) async {
    try {
      // In a real implementation, you would use an image processing library
      // to resize the image. For now, we'll return the original file.
      return imageFile;
    } catch (e) {
      print('Error resizing image: $e');
      return null;
    }
  }

  // Extract dominant colors from image
  Future<List<String>> extractDominantColors(File imageFile) async {
    try {
      // In a real implementation, you would analyze the image pixels
      // to extract dominant colors. For now, we'll return some sample colors.
      return [
        '#FF6B6B', // Red
        '#4ECDC4', // Teal
        '#45B7D1', // Blue
        '#96CEB4', // Green
        '#FFEAA7', // Yellow
      ];
    } catch (e) {
      print('Error extracting dominant colors: $e');
      return [];
    }
  }

  // Check if image contains inappropriate content
  Future<bool> isImageAppropriate(File imageFile) async {
    try {
      // In a real implementation, you would use a content moderation service
      // For now, we'll assume all images are appropriate
      return true;
    } catch (e) {
      print('Error checking image appropriateness: $e');
      return true; // Default to appropriate if check fails
    }
  }

  // Create thumbnail from image
  Future<File?> createThumbnail(File imageFile, {int size = 200}) async {
    try {
      // In a real implementation, you would create a smaller version of the image
      // For now, we'll return the original file
      return imageFile;
    } catch (e) {
      print('Error creating thumbnail: $e');
      return null;
    }
  }

  // Batch process multiple images
  Future<List<File>> batchProcessImages(List<File> imageFiles) async {
    final processedImages = <File>[];
    
    for (final imageFile in imageFiles) {
      try {
        // Compress and resize each image
        final compressed = await compressImage(imageFile);
        if (compressed != null) {
          final resized = await resizeImage(compressed);
          if (resized != null) {
            processedImages.add(resized);
          }
        }
      } catch (e) {
        print('Error processing image ${imageFile.path}: $e');
      }
    }
    
    return processedImages;
  }

  // Get image metadata
  Future<Map<String, dynamic>?> getImageMetadata(File imageFile) async {
    try {
      final stat = await imageFile.stat();
      final dimensions = await getImageDimensions(imageFile);
      
      return {
        'size': stat.size,
        'modified': stat.modified.toIso8601String(),
        'width': dimensions?['width'],
        'height': dimensions?['height'],
        'path': imageFile.path,
        'name': imageFile.path.split('/').last,
      };
    } catch (e) {
      print('Error getting image metadata: $e');
      return null;
    }
  }

  // Clean up temporary files
  Future<void> cleanupTempFiles() async {
    try {
      // In a real implementation, you would clean up any temporary files
      // created during image processing
    } catch (e) {
      print('Error cleaning up temp files: $e');
    }
  }

  // Check permissions
  Future<bool> checkPermissions() async {
    final cameraPermission = await Permission.camera.status;
    final photosPermission = await Permission.photos.status;
    
    return cameraPermission.isGranted && photosPermission.isGranted;
  }

  // Request permissions
  Future<bool> requestPermissions() async {
    final permissions = await [
      Permission.camera,
      Permission.photos,
    ].request();
    
    return permissions.values.every((status) => status.isGranted);
  }
}
