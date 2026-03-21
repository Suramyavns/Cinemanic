// models/media_response.dart

class TrendingDataClass {
  final int page;
  final List<MediaItem> results;
  final int totalPages;
  final int totalResults;

  TrendingDataClass({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TrendingDataClass.fromJson(Map<String, dynamic> json) {
    return TrendingDataClass(
      page: json['page'] as int,
      results: (json['results'] as List<dynamic>)
          .map((item) => MediaItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'results': results.map((item) => item.toJson()).toList(),
    'total_pages': totalPages,
    'total_results': totalResults,
  };
}

// models/media_item.dart

enum MediaType { movie, tv, unknown }

class MediaItem {
  final bool adult;
  final String? backdropPath;
  final int id;
  final String title; // unified: covers both 'title' and 'name'
  final String originalLanguage;
  final String
  originalTitle; // covers both 'original_title' and 'original_name'
  final String overview;
  final String? posterPath;
  final MediaType mediaType;
  final List<int> genreIds;
  final double popularity;
  final String? releaseDate; // movies
  final String? firstAirDate; // tv shows
  final bool? video;
  final double voteAverage;
  final int voteCount;
  final List<String>? originCountry; // tv shows only

  MediaItem({
    required this.adult,
    this.backdropPath,
    required this.id,
    required this.title,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    this.posterPath,
    required this.mediaType,
    required this.genreIds,
    required this.popularity,
    this.releaseDate,
    this.firstAirDate,
    this.video,
    required this.voteAverage,
    required this.voteCount,
    this.originCountry,
  });

  bool get isMovie => mediaType == MediaType.movie;
  bool get isTvShow => mediaType == MediaType.tv;

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    final mediaTypeStr = json['media_type'] as String?;
    final mediaType = mediaTypeStr == 'movie'
        ? MediaType.movie
        : mediaTypeStr == 'tv'
        ? MediaType.tv
        : MediaType.unknown;

    return MediaItem(
      adult: json['adult'] as bool,
      backdropPath: json['backdrop_path'] as String?,
      id: json['id'] as int,
      title: (json['title'] ?? json['name'] ?? '') as String,
      originalLanguage: json['original_language'] as String,
      originalTitle:
          (json['original_title'] ?? json['original_name'] ?? '') as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String?,
      mediaType: mediaType,
      genreIds: (json['genre_ids'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      popularity: (json['popularity'] as num).toDouble(),
      releaseDate: json['release_date'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      video: json['video'] as bool?,
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
      originCountry: (json['origin_country'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'adult': adult,
    if (backdropPath != null) 'backdrop_path': backdropPath,
    'id': id,
    if (isMovie) 'title': title else 'name': title,
    'original_language': originalLanguage,
    if (isMovie)
      'original_title': originalTitle
    else
      'original_name': originalTitle,
    'overview': overview,
    if (posterPath != null) 'poster_path': posterPath,
    'media_type': isMovie
        ? 'movie'
        : isTvShow
        ? 'tv'
        : 'unknown',
    'genre_ids': genreIds,
    'popularity': popularity,
    if (releaseDate != null) 'release_date': releaseDate,
    if (firstAirDate != null) 'first_air_date': firstAirDate,
    if (video != null) 'video': video,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    if (originCountry != null) 'origin_country': originCountry,
  };
}
