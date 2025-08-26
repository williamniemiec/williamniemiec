enum GameCategory {
  action,
  adventure,
  puzzle,
  strategy,
  casual,
  rpg,
  simulation,
  sports,
  racing,
  arcade,
}

enum GamePlatform {
  android,
  ios,
  both,
}

class Game {
  final String id;
  final String title;
  final String description;
  final String iconUrl;
  final String bannerUrl;
  final List<String> screenshotUrls;
  final GameCategory category;
  final GamePlatform platform;
  final String packageName;
  final String version;
  final int sizeInMB;
  final double rating;
  final int downloadCount;
  final bool isInstalled;
  final bool isDownloading;
  final DateTime releaseDate;
  final DateTime addedToNetflix;
  final List<String> supportedLanguages;
  final String minOSVersion;
  final bool requiresInternet;
  final Map<String, dynamic> metadata;

  const Game({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.bannerUrl,
    required this.screenshotUrls,
    required this.category,
    required this.platform,
    required this.packageName,
    required this.version,
    required this.sizeInMB,
    required this.rating,
    required this.downloadCount,
    required this.isInstalled,
    required this.isDownloading,
    required this.releaseDate,
    required this.addedToNetflix,
    required this.supportedLanguages,
    required this.minOSVersion,
    required this.requiresInternet,
    required this.metadata,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      bannerUrl: json['bannerUrl'] as String,
      screenshotUrls: List<String>.from(json['screenshotUrls'] as List<dynamic>),
      category: GameCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
      ),
      platform: GamePlatform.values.firstWhere(
        (e) => e.toString().split('.').last == json['platform'],
      ),
      packageName: json['packageName'] as String,
      version: json['version'] as String,
      sizeInMB: json['sizeInMB'] as int,
      rating: (json['rating'] as num).toDouble(),
      downloadCount: json['downloadCount'] as int,
      isInstalled: json['isInstalled'] as bool,
      isDownloading: json['isDownloading'] as bool,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      addedToNetflix: DateTime.parse(json['addedToNetflix'] as String),
      supportedLanguages: List<String>.from(json['supportedLanguages'] as List<dynamic>),
      minOSVersion: json['minOSVersion'] as String,
      requiresInternet: json['requiresInternet'] as bool,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconUrl': iconUrl,
      'bannerUrl': bannerUrl,
      'screenshotUrls': screenshotUrls,
      'category': category.toString().split('.').last,
      'platform': platform.toString().split('.').last,
      'packageName': packageName,
      'version': version,
      'sizeInMB': sizeInMB,
      'rating': rating,
      'downloadCount': downloadCount,
      'isInstalled': isInstalled,
      'isDownloading': isDownloading,
      'releaseDate': releaseDate.toIso8601String(),
      'addedToNetflix': addedToNetflix.toIso8601String(),
      'supportedLanguages': supportedLanguages,
      'minOSVersion': minOSVersion,
      'requiresInternet': requiresInternet,
      'metadata': metadata,
    };
  }

  Game copyWith({
    String? id,
    String? title,
    String? description,
    String? iconUrl,
    String? bannerUrl,
    List<String>? screenshotUrls,
    GameCategory? category,
    GamePlatform? platform,
    String? packageName,
    String? version,
    int? sizeInMB,
    double? rating,
    int? downloadCount,
    bool? isInstalled,
    bool? isDownloading,
    DateTime? releaseDate,
    DateTime? addedToNetflix,
    List<String>? supportedLanguages,
    String? minOSVersion,
    bool? requiresInternet,
    Map<String, dynamic>? metadata,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      screenshotUrls: screenshotUrls ?? this.screenshotUrls,
      category: category ?? this.category,
      platform: platform ?? this.platform,
      packageName: packageName ?? this.packageName,
      version: version ?? this.version,
      sizeInMB: sizeInMB ?? this.sizeInMB,
      rating: rating ?? this.rating,
      downloadCount: downloadCount ?? this.downloadCount,
      isInstalled: isInstalled ?? this.isInstalled,
      isDownloading: isDownloading ?? this.isDownloading,
      releaseDate: releaseDate ?? this.releaseDate,
      addedToNetflix: addedToNetflix ?? this.addedToNetflix,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
      minOSVersion: minOSVersion ?? this.minOSVersion,
      requiresInternet: requiresInternet ?? this.requiresInternet,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedSize {
    if (sizeInMB < 1024) {
      return '${sizeInMB}MB';
    } else {
      return '${(sizeInMB / 1024).toStringAsFixed(1)}GB';
    }
  }

  String get formattedDownloadCount {
    if (downloadCount < 1000) {
      return downloadCount.toString();
    } else if (downloadCount < 1000000) {
      return '${(downloadCount / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(downloadCount / 1000000).toStringAsFixed(1)}M';
    }
  }

  String get categoryDisplayName {
    switch (category) {
      case GameCategory.action:
        return 'Action';
      case GameCategory.adventure:
        return 'Adventure';
      case GameCategory.puzzle:
        return 'Puzzle';
      case GameCategory.strategy:
        return 'Strategy';
      case GameCategory.casual:
        return 'Casual';
      case GameCategory.rpg:
        return 'RPG';
      case GameCategory.simulation:
        return 'Simulation';
      case GameCategory.sports:
        return 'Sports';
      case GameCategory.racing:
        return 'Racing';
      case GameCategory.arcade:
        return 'Arcade';
    }
  }

  bool get canInstall {
    return !isInstalled && !isDownloading;
  }

  bool get canPlay {
    return isInstalled && !isDownloading;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Game &&
        other.id == id &&
        other.packageName == packageName;
  }

  @override
  int get hashCode {
    return id.hashCode ^ packageName.hashCode;
  }

  @override
  String toString() {
    return 'Game(id: $id, title: $title, category: $category, isInstalled: $isInstalled)';
  }
}