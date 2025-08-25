import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class AppUtils {
  // Date and Time Formatting
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return formatDate(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // File Size Formatting
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  // Color Utilities
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  static Color getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  static List<Color> generateColorPalette(Color baseColor, {int count = 5}) {
    final hsl = HSLColor.fromColor(baseColor);
    final colors = <Color>[];
    
    for (int i = 0; i < count; i++) {
      final lightness = (0.2 + (0.6 * i / (count - 1))).clamp(0.0, 1.0);
      colors.add(hsl.withLightness(lightness).toColor());
    }
    
    return colors;
  }

  // Dimension Utilities
  static Size calculateAspectRatioSize(Size originalSize, double maxWidth, double maxHeight) {
    final aspectRatio = originalSize.width / originalSize.height;
    
    double width = maxWidth;
    double height = width / aspectRatio;
    
    if (height > maxHeight) {
      height = maxHeight;
      width = height * aspectRatio;
    }
    
    return Size(width, height);
  }

  static Offset constrainOffset(Offset offset, Size containerSize, Size objectSize) {
    final maxX = containerSize.width - objectSize.width;
    final maxY = containerSize.height - objectSize.height;
    
    return Offset(
      offset.dx.clamp(0.0, maxX),
      offset.dy.clamp(0.0, maxY),
    );
  }

  // File Operations
  static Future<String> getTemporaryPath() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  static Future<String> getApplicationDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS doesn't need explicit storage permission for app documents
  }

  static Future<void> saveFileToDevice(Uint8List bytes, String fileName) async {
    try {
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
    } catch (e) {
      throw Exception('Failed to save file: $e');
    }
  }

  static Future<void> shareFile(String filePath, {String? text}) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        text: text,
      );
    } catch (e) {
      throw Exception('Failed to share file: $e');
    }
  }

  // Validation Utilities
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  static bool isValidHexColor(String hex) {
    return RegExp(r'^#?([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$').hasMatch(hex);
  }

  // String Utilities
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String generateRandomId({int length = 8}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // UI Utilities
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void hapticFeedback() {
    HapticFeedback.lightImpact();
  }

  // Math Utilities
  static double degreeToRadian(double degree) {
    return degree * pi / 180;
  }

  static double radianToDegree(double radian) {
    return radian * 180 / pi;
  }

  static double distance(Offset point1, Offset point2) {
    return sqrt(pow(point2.dx - point1.dx, 2) + pow(point2.dy - point1.dy, 2));
  }

  static double angle(Offset center, Offset point) {
    return atan2(point.dy - center.dy, point.dx - center.dx);
  }

  // Design Utilities
  static Size getDesignSize(String formatName) {
    const formats = {
      'Instagram Post': Size(1080, 1080),
      'Instagram Story': Size(1080, 1920),
      'Facebook Post': Size(1200, 630),
      'Twitter Post': Size(1024, 512),
      'LinkedIn Post': Size(1200, 627),
      'YouTube Thumbnail': Size(1280, 720),
      'Presentation': Size(1920, 1080),
      'A4 Document': Size(2480, 3508),
      'Business Card': Size(1050, 600),
      'Flyer': Size(2480, 3508),
      'Logo': Size(500, 500),
      'Banner': Size(1500, 500),
    };
    
    return formats[formatName] ?? const Size(1080, 1080);
  }

  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  static bool isImageFile(String fileName) {
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(getFileExtension(fileName));
  }

  static bool isVideoFile(String fileName) {
    const videoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'webm'];
    return videoExtensions.contains(getFileExtension(fileName));
  }

  // Performance Utilities
  static Future<void> debounce(Duration duration, VoidCallback callback) async {
    await Future.delayed(duration);
    callback();
  }

  static DateTime? _lastThrottleCall;
  
  static T? throttle<T>(T? Function() callback, Duration duration) {
    final now = DateTime.now();
    
    if (_lastThrottleCall == null || now.difference(_lastThrottleCall!) >= duration) {
      _lastThrottleCall = now;
      return callback();
    }
    
    return null;
  }
}