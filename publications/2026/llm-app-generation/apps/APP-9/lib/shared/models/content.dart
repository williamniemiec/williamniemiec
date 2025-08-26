enum ContentType {
  movie,
  tvShow,
  documentary,
  anime,
  standup,
  game,
}

enum MaturityRating {
  g,
  pg,
  pg13,
  r,
  nc17,
  tvY,
  tvY7,
  tvG,
  tvPG,
  tv14,
  tvMA,
}

class Content {
  final String id;
  final String title;
  final String description;
  final ContentType type;
  final String posterUrl;
  final String backdropUrl;
  final String? trailerUrl;
  final MaturityRating maturityRating;
  final List<String> genres;
  final List<String> cast;
  final List<String> directors;
  final int releaseYear;
  final double rating;
  final int duration; // in minutes for movies, episodes for TV shows
  final List<String> languages;
  final List<String> subtitles;
  final bool isNetflixOriginal;
  final bool isAvailableForDownload;
  final DateTime addedToNetflix;
  final List<Episode>? episodes; // for TV shows
  final int? numberOfSeasons;
  final Map<String, dynamic> metadata;

  const Content({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.posterUrl,
    required this.backdropUrl,
    this.trailerUrl,
    required this.maturityRating,
    required this.genres,
    required this.cast,
    required this.directors,
    required this.releaseYear,
    required this.rating,
    required this.duration,
    required this.languages,
    required this.subtitles,
    required this.isNetflixOriginal,
    required this.isAvailableForDownload,
    required this.addedToNetflix,
    this.episodes,
    this.numberOfSeasons,
    required this.metadata,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: ContentType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      posterUrl: json['posterUrl'] as String,
      backdropUrl: json['backdropUrl'] as String,
      trailerUrl: json['trailerUrl'] as String?,
      maturityRating: MaturityRating.values.firstWhere(
        (e) => e.toString().split('.').last == json['maturityRating'],
      ),
      genres: List<String>.from(json['genres'] as List<dynamic>),
      cast: List<String>.from(json['cast'] as List<dynamic>),
      directors: List<String>.from(json['directors'] as List<dynamic>),
      releaseYear: json['releaseYear'] as int,
      rating: (json['rating'] as num).toDouble(),
      duration: json['duration'] as int,
      languages: List<String>.from(json['languages'] as List<dynamic>),
      subtitles: List<String>.from(json['subtitles'] as List<dynamic>),
      isNetflixOriginal: json['isNetflixOriginal'] as bool,
      isAvailableForDownload: json['isAvailableForDownload'] as bool,
      addedToNetflix: DateTime.parse(json['addedToNetflix'] as String),
      episodes: json['episodes'] != null
          ? (json['episodes'] as List<dynamic>)
              .map((episode) => Episode.fromJson(episode as Map<String, dynamic>))
              .toList()
          : null,
      numberOfSeasons: json['numberOfSeasons'] as int?,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl,
      'trailerUrl': trailerUrl,
      'maturityRating': maturityRating.toString().split('.').last,
      'genres': genres,
      'cast': cast,
      'directors': directors,
      'releaseYear': releaseYear,
      'rating': rating,
      'duration': duration,
      'languages': languages,
      'subtitles': subtitles,
      'isNetflixOriginal': isNetflixOriginal,
      'isAvailableForDownload': isAvailableForDownload,
      'addedToNetflix': addedToNetflix.toIso8601String(),
      'episodes': episodes?.map((episode) => episode.toJson()).toList(),
      'numberOfSeasons': numberOfSeasons,
      'metadata': metadata,
    };
  }

  Content copyWith({
    String? id,
    String? title,
    String? description,
    ContentType? type,
    String? posterUrl,
    String? backdropUrl,
    String? trailerUrl,
    MaturityRating? maturityRating,
    List<String>? genres,
    List<String>? cast,
    List<String>? directors,
    int? releaseYear,
    double? rating,
    int? duration,
    List<String>? languages,
    List<String>? subtitles,
    bool? isNetflixOriginal,
    bool? isAvailableForDownload,
    DateTime? addedToNetflix,
    List<Episode>? episodes,
    int? numberOfSeasons,
    Map<String, dynamic>? metadata,
  }) {
    return Content(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      maturityRating: maturityRating ?? this.maturityRating,
      genres: genres ?? this.genres,
      cast: cast ?? this.cast,
      directors: directors ?? this.directors,
      releaseYear: releaseYear ?? this.releaseYear,
      rating: rating ?? this.rating,
      duration: duration ?? this.duration,
      languages: languages ?? this.languages,
      subtitles: subtitles ?? this.subtitles,
      isNetflixOriginal: isNetflixOriginal ?? this.isNetflixOriginal,
      isAvailableForDownload: isAvailableForDownload ?? this.isAvailableForDownload,
      addedToNetflix: addedToNetflix ?? this.addedToNetflix,
      episodes: episodes ?? this.episodes,
      numberOfSeasons: numberOfSeasons ?? this.numberOfSeasons,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedDuration {
    if (type == ContentType.movie) {
      final hours = duration ~/ 60;
      final minutes = duration % 60;
      if (hours > 0) {
        return '${hours}h ${minutes}m';
      } else {
        return '${minutes}m';
      }
    } else {
      return '$numberOfSeasons Season${numberOfSeasons! > 1 ? 's' : ''}';
    }
  }

  String get maturityRatingDisplay {
    switch (maturityRating) {
      case MaturityRating.g:
        return 'G';
      case MaturityRating.pg:
        return 'PG';
      case MaturityRating.pg13:
        return 'PG-13';
      case MaturityRating.r:
        return 'R';
      case MaturityRating.nc17:
        return 'NC-17';
      case MaturityRating.tvY:
        return 'TV-Y';
      case MaturityRating.tvY7:
        return 'TV-Y7';
      case MaturityRating.tvG:
        return 'TV-G';
      case MaturityRating.tvPG:
        return 'TV-PG';
      case MaturityRating.tv14:
        return 'TV-14';
      case MaturityRating.tvMA:
        return 'TV-MA';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Content &&
        other.id == id &&
        other.title == title &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ type.hashCode;
  }

  @override
  String toString() {
    return 'Content(id: $id, title: $title, type: $type, rating: $rating)';
  }
}

class Episode {
  final String id;
  final String contentId;
  final int seasonNumber;
  final int episodeNumber;
  final String title;
  final String description;
  final String thumbnailUrl;
  final int duration; // in minutes
  final String? videoUrl;
  final DateTime releaseDate;
  final bool isAvailableForDownload;

  const Episode({
    required this.id,
    required this.contentId,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.duration,
    this.videoUrl,
    required this.releaseDate,
    required this.isAvailableForDownload,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as String,
      contentId: json['contentId'] as String,
      seasonNumber: json['seasonNumber'] as int,
      episodeNumber: json['episodeNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      duration: json['duration'] as int,
      videoUrl: json['videoUrl'] as String?,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      isAvailableForDownload: json['isAvailableForDownload'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contentId': contentId,
      'seasonNumber': seasonNumber,
      'episodeNumber': episodeNumber,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'videoUrl': videoUrl,
      'releaseDate': releaseDate.toIso8601String(),
      'isAvailableForDownload': isAvailableForDownload,
    };
  }

  Episode copyWith({
    String? id,
    String? contentId,
    int? seasonNumber,
    int? episodeNumber,
    String? title,
    String? description,
    String? thumbnailUrl,
    int? duration,
    String? videoUrl,
    DateTime? releaseDate,
    bool? isAvailableForDownload,
  }) {
    return Episode(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      videoUrl: videoUrl ?? this.videoUrl,
      releaseDate: releaseDate ?? this.releaseDate,
      isAvailableForDownload: isAvailableForDownload ?? this.isAvailableForDownload,
    );
  }

  String get formattedDuration {
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get episodeTitle {
    return 'S$seasonNumber:E$episodeNumber $title';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Episode &&
        other.id == id &&
        other.contentId == contentId &&
        other.seasonNumber == seasonNumber &&
        other.episodeNumber == episodeNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^ contentId.hashCode ^ seasonNumber.hashCode ^ episodeNumber.hashCode;
  }

  @override
  String toString() {
    return 'Episode(id: $id, S$seasonNumber:E$episodeNumber, title: $title)';
  }
}