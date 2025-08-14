class TvShow {
  final int id;
  final String name;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final double voteAverage;

  TvShow({
    required this.id,
    required this.name,
    this.posterPath,
    this.backdropPath,
    this.overview,
    required this.voteAverage,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json['id'],
      name: json['name'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      overview: json['overview'],
      voteAverage: json['vote_average'].toDouble(),
    );
  }
}