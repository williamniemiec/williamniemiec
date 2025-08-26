enum DownloadStatus {
  pending,
  downloading,
  completed,
  failed,
  paused,
}

enum DownloadQuality {
  standard,
  high,
}

class Download {
  final String id;
  final String contentId;
  final String? episodeId; // null for movies, set for TV show episodes
  final String title;
  final String thumbnailUrl;
  final DownloadStatus status;
  final DownloadQuality quality;
  final int totalSize; // in bytes
  final int downloadedSize; // in bytes
  final String localPath;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime expiresAt;
  final String profileId;

  const Download({
    required this.id,
    required this.contentId,
    this.episodeId,
    required this.title,
    required this.thumbnailUrl,
    required this.status,
    required this.quality,
    required this.totalSize,
    required this.downloadedSize,
    required this.localPath,
    required this.createdAt,
    this.completedAt,
    required this.expiresAt,
    required this.profileId,
  });

  factory Download.fromJson(Map<String, dynamic> json) {
    return Download(
      id: json['id'] as String,
      contentId: json['contentId'] as String,
      episodeId: json['episodeId'] as String?,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      status: DownloadStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      quality: DownloadQuality.values.firstWhere(
        (e) => e.toString().split('.').last == json['quality'],
      ),
      totalSize: json['totalSize'] as int,
      downloadedSize: json['downloadedSize'] as int,
      localPath: json['localPath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      profileId: json['profileId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contentId': contentId,
      'episodeId': episodeId,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'status': status.toString().split('.').last,
      'quality': quality.toString().split('.').last,
      'totalSize': totalSize,
      'downloadedSize': downloadedSize,
      'localPath': localPath,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'profileId': profileId,
    };
  }

  Download copyWith({
    String? id,
    String? contentId,
    String? episodeId,
    String? title,
    String? thumbnailUrl,
    DownloadStatus? status,
    DownloadQuality? quality,
    int? totalSize,
    int? downloadedSize,
    String? localPath,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? expiresAt,
    String? profileId,
  }) {
    return Download(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      episodeId: episodeId ?? this.episodeId,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      status: status ?? this.status,
      quality: quality ?? this.quality,
      totalSize: totalSize ?? this.totalSize,
      downloadedSize: downloadedSize ?? this.downloadedSize,
      localPath: localPath ?? this.localPath,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      profileId: profileId ?? this.profileId,
    );
  }

  double get progress {
    if (totalSize == 0) return 0.0;
    return downloadedSize / totalSize;
  }

  String get formattedSize {
    return _formatBytes(totalSize);
  }

  String get formattedDownloadedSize {
    return _formatBytes(downloadedSize);
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  bool get isCompleted {
    return status == DownloadStatus.completed;
  }

  bool get isDownloading {
    return status == DownloadStatus.downloading;
  }

  bool get canPlay {
    return isCompleted && !isExpired;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Download &&
        other.id == id &&
        other.contentId == contentId &&
        other.episodeId == episodeId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ contentId.hashCode ^ (episodeId?.hashCode ?? 0);
  }

  @override
  String toString() {
    return 'Download(id: $id, title: $title, status: $status, progress: ${(progress * 100).toStringAsFixed(1)}%)';
  }
}