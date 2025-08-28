import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import '../models/video_project.dart';

class VideoService {
  static final VideoService _instance = VideoService._internal();
  factory VideoService() => _instance;
  VideoService._internal();

  final Map<String, VideoPlayerController> _controllers = {};

  /// Get video controller for a file path
  VideoPlayerController? getController(String filePath) {
    return _controllers[filePath];
  }

  /// Initialize video controller
  Future<VideoPlayerController> initializeController(String filePath) async {
    if (_controllers.containsKey(filePath)) {
      return _controllers[filePath]!;
    }

    final controller = VideoPlayerController.file(File(filePath));
    await controller.initialize();
    _controllers[filePath] = controller;
    return controller;
  }

  /// Dispose video controller
  void disposeController(String filePath) {
    final controller = _controllers[filePath];
    if (controller != null) {
      controller.dispose();
      _controllers.remove(filePath);
    }
  }

  /// Dispose all controllers
  void disposeAllControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  /// Get video duration
  Future<Duration> getVideoDuration(String filePath) async {
    final controller = await initializeController(filePath);
    return controller.value.duration;
  }

  /// Generate video thumbnail
  Future<String?> generateThumbnail(String videoPath, {int timeMs = 0}) async {
    try {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 200,
        quality: 75,
        timeMs: timeMs,
      );
      return thumbnailPath;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }

  /// Generate multiple thumbnails for timeline
  Future<List<String>> generateTimelineThumbnails(
    String videoPath,
    Duration duration,
    int count,
  ) async {
    final thumbnails = <String>[];
    final interval = duration.inMilliseconds ~/ count;

    for (int i = 0; i < count; i++) {
      final timeMs = i * interval;
      final thumbnail = await generateThumbnail(videoPath, timeMs: timeMs);
      if (thumbnail != null) {
        thumbnails.add(thumbnail);
      }
    }

    return thumbnails;
  }

  /// Trim video clip
  Future<String?> trimVideo({
    required String inputPath,
    required Duration startTime,
    required Duration endTime,
    String? outputPath,
  }) async {
    try {
      outputPath ??= await _generateOutputPath('trimmed_video.mp4');
      
      final command = '-i "$inputPath" -ss ${_formatDuration(startTime)} '
          '-t ${_formatDuration(endTime - startTime)} -c copy "$outputPath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      } else {
        print('FFmpeg trim failed with return code: $returnCode');
        return null;
      }
    } catch (e) {
      print('Error trimming video: $e');
      return null;
    }
  }

  /// Change video speed
  Future<String?> changeVideoSpeed({
    required String inputPath,
    required double speed,
    String? outputPath,
  }) async {
    try {
      outputPath ??= await _generateOutputPath('speed_video.mp4');
      
      final videoFilter = 'setpts=${1/speed}*PTS';
      final audioFilter = 'atempo=$speed';
      
      final command = '-i "$inputPath" -filter_complex '
          '"[0:v]$videoFilter[v];[0:a]$audioFilter[a]" '
          '-map "[v]" -map "[a]" "$outputPath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      } else {
        print('FFmpeg speed change failed with return code: $returnCode');
        return null;
      }
    } catch (e) {
      print('Error changing video speed: $e');
      return null;
    }
  }

  /// Merge multiple video clips
  Future<String?> mergeVideos({
    required List<String> inputPaths,
    String? outputPath,
  }) async {
    try {
      if (inputPaths.isEmpty) return null;
      
      outputPath ??= await _generateOutputPath('merged_video.mp4');
      
      // Create concat file
      final tempDir = await getTemporaryDirectory();
      final concatFile = File('${tempDir.path}/concat_list.txt');
      
      final concatContent = inputPaths
          .map((path) => "file '$path'")
          .join('\n');
      
      await concatFile.writeAsString(concatContent);
      
      final command = '-f concat -safe 0 -i "${concatFile.path}" -c copy "$outputPath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      // Clean up concat file
      await concatFile.delete();

      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      } else {
        print('FFmpeg merge failed with return code: $returnCode');
        return null;
      }
    } catch (e) {
      print('Error merging videos: $e');
      return null;
    }
  }

  /// Apply video filter
  Future<String?> applyVideoFilter({
    required String inputPath,
    required String filterName,
    Map<String, dynamic>? parameters,
    String? outputPath,
  }) async {
    try {
      outputPath ??= await _generateOutputPath('filtered_video.mp4');
      
      String filterString = filterName;
      if (parameters != null && parameters.isNotEmpty) {
        final paramString = parameters.entries
            .map((e) => '${e.key}=${e.value}')
            .join(':');
        filterString = '$filterName=$paramString';
      }
      
      final command = '-i "$inputPath" -vf "$filterString" "$outputPath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      } else {
        print('FFmpeg filter failed with return code: $returnCode');
        return null;
      }
    } catch (e) {
      print('Error applying video filter: $e');
      return null;
    }
  }

  /// Extract audio from video
  Future<String?> extractAudio({
    required String inputPath,
    String? outputPath,
  }) async {
    try {
      outputPath ??= await _generateOutputPath('extracted_audio.aac');
      
      final command = '-i "$inputPath" -vn -acodec copy "$outputPath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      } else {
        print('FFmpeg audio extraction failed with return code: $returnCode');
        return null;
      }
    } catch (e) {
      print('Error extracting audio: $e');
      return null;
    }
  }

  /// Add audio to video
  Future<String?> addAudioToVideo({
    required String videoPath,
    required String audioPath,
    double audioVolume = 1.0,
    String? outputPath,
  }) async {
    try {
      outputPath ??= await _generateOutputPath('video_with_audio.mp4');
      
      final command = '-i "$videoPath" -i "$audioPath" '
          '-filter_complex "[1:a]volume=$audioVolume[a1];[0:a][a1]amix=inputs=2[a]" '
          '-map 0:v -map "[a]" -c:v copy -c:a aac "$outputPath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      } else {
        print('FFmpeg add audio failed with return code: $returnCode');
        return null;
      }
    } catch (e) {
      print('Error adding audio to video: $e');
      return null;
    }
  }

  /// Export final video project
  Future<String?> exportProject({
    required VideoProject project,
    required String outputPath,
    Function(double)? onProgress,
  }) async {
    try {
      // This is a simplified export - in a real app, you'd need to:
      // 1. Create a complex FFmpeg command based on all project elements
      // 2. Handle timeline positioning, effects, transitions, etc.
      // 3. Provide progress updates
      
      if (project.clips.isEmpty) return null;
      
      // For now, just merge the clips
      final clipPaths = project.clips.map((clip) => clip.filePath).toList();
      return await mergeVideos(inputPaths: clipPaths, outputPath: outputPath);
      
    } catch (e) {
      print('Error exporting project: $e');
      return null;
    }
  }

  /// Get video information
  Future<VideoInfo?> getVideoInfo(String filePath) async {
    try {
      final controller = await initializeController(filePath);
      final file = File(filePath);
      final stats = await file.stat();
      
      return VideoInfo(
        duration: controller.value.duration,
        size: controller.value.size,
        fileSize: stats.size,
        filePath: filePath,
      );
    } catch (e) {
      print('Error getting video info: $e');
      return null;
    }
  }

  // Helper methods
  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = (duration.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds.$milliseconds';
  }

  Future<String> _generateOutputPath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final outputDir = Directory('${directory.path}/capcut_exports');
    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }
    return '${outputDir.path}/${DateTime.now().millisecondsSinceEpoch}_$filename';
  }
}

class VideoInfo {
  final Duration duration;
  final Size size;
  final int fileSize;
  final String filePath;

  const VideoInfo({
    required this.duration,
    required this.size,
    required this.fileSize,
    required this.filePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'duration': duration.inMilliseconds,
      'width': size.width,
      'height': size.height,
      'fileSize': fileSize,
      'filePath': filePath,
    };
  }

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      duration: Duration(milliseconds: json['duration']),
      size: Size(json['width'], json['height']),
      fileSize: json['fileSize'],
      filePath: json['filePath'],
    );
  }
}