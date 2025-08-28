import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'TikTok';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.tiktok.com/v1';
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Video Configuration
  static const int maxVideoDuration = 60; // seconds
  static const int minVideoDuration = 3; // seconds
  static const double videoAspectRatio = 9 / 16;
  static const int maxVideoFileSize = 100 * 1024 * 1024; // 100MB
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 20.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Colors
  static const Color primaryColor = Color(0xFFFF0050);
  static const Color secondaryColor = Color(0xFF25F4EE);
  static const Color backgroundColor = Color(0xFF000000);
  static const Color surfaceColor = Color(0xFF161823);
  static const Color textPrimaryColor = Color(0xFFFFFFFF);
  static const Color textSecondaryColor = Color(0xFFBBBBBB);
  static const Color iconColor = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFF2F2F2F);
  
  // Social Actions
  static const double likeButtonSize = 48.0;
  static const double shareButtonSize = 48.0;
  static const double commentButtonSize = 48.0;
  static const double profileImageSize = 48.0;
  static const double smallProfileImageSize = 32.0;
  
  // Feed Configuration
  static const int videosPerPage = 10;
  static const double preloadDistance = 2.0;
  
  // Camera Configuration
  static const List<String> supportedVideoFormats = ['mp4', 'mov', 'avi'];
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png'];
  
  // Text Limits
  static const int maxCaptionLength = 300;
  static const int maxCommentLength = 150;
  static const int maxBioLength = 80;
  static const int maxUsernameLength = 20;
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  static const String cacheKey = 'app_cache';
  
  // Routes
  static const String homeRoute = '/';
  static const String profileRoute = '/profile';
  static const String cameraRoute = '/camera';
  static const String searchRoute = '/search';
  static const String inboxRoute = '/inbox';
  static const String discoverRoute = '/discover';
  static const String videoPlayerRoute = '/video-player';
  static const String commentsRoute = '/comments';
  static const String chatRoute = '/chat';
  static const String editProfileRoute = '/edit-profile';
  
  // Error Messages
  static const String networkError = 'Network connection error. Please try again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
  static const String videoLoadError = 'Failed to load video.';
  static const String cameraError = 'Camera access error.';
  static const String permissionError = 'Permission denied.';
  
  // Success Messages
  static const String videoUploadSuccess = 'Video uploaded successfully!';
  static const String profileUpdateSuccess = 'Profile updated successfully!';
  static const String followSuccess = 'User followed successfully!';
  static const String unfollowSuccess = 'User unfollowed successfully!';
  
  // Placeholder Data
  static const String placeholderVideoUrl = 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4';
  static const String placeholderImageUrl = 'https://via.placeholder.com/300x300';
  static const String placeholderProfileImage = 'https://via.placeholder.com/150x150';
}