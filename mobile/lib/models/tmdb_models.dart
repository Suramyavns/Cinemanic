// ============================================================
// TMDB Search Response Models
// Generated from TMDB /search/multi API response
// ============================================================

enum MediaType { movie, tv, unknown }

class TmdbSearchResponse {
  final int page;
  final List<TmdbMedia> results;
  final int totalPages;
  final int totalResults;

  const TmdbSearchResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TmdbSearchResponse.fromJson(Map<String, dynamic> json) {
    return TmdbSearchResponse(
      page: json['page'] as int,
      results: (json['results'] as List<dynamic>)
          .map((e) => TmdbMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'results': results.map((e) => e.toJson()).toList(),
    'total_pages': totalPages,
    'total_results': totalResults,
  };

  @override
  String toString() =>
      'TmdbSearchResponse(page: $page, totalResults: $totalResults, results: ${results.length} items)';
}

class TmdbMedia {
  final int id;
  final bool adult;
  final MediaType mediaType;
  final List<int> genreIds;
  final double popularity;
  final double voteAverage;
  final int voteCount;
  final String? backdropPath;
  final String? posterPath;
  final String? originalLanguage;
  final String overview;

  // Movie-specific fields
  final String? title;
  final String? originalTitle;
  final String? releaseDate;
  final bool? video;

  // TV-specific fields
  final String? name;
  final String? originalName;
  final String? firstAirDate;
  final List<String>? originCountry;

  const TmdbMedia({
    required this.id,
    required this.adult,
    required this.mediaType,
    required this.genreIds,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
    required this.overview,
    this.backdropPath,
    this.posterPath,
    this.originalLanguage,
    this.title,
    this.originalTitle,
    this.releaseDate,
    this.video,
    this.name,
    this.originalName,
    this.firstAirDate,
    this.originCountry,
  });

  /// Display title — falls back to name (TV) or title (movie)
  String get displayTitle => title ?? name ?? 'Unknown';

  /// Display date — release date for movies, first air date for TV
  String? get displayDate => releaseDate ?? firstAirDate;

  bool get isMovie => mediaType == MediaType.movie;
  bool get isTv => mediaType == MediaType.tv;

  /// Full poster URL using TMDB image base URL (w500 size)
  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  /// Full backdrop URL using TMDB image base URL (w1280 size)
  String? get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : null;

  factory TmdbMedia.fromJson(Map<String, dynamic> json) {
    final mediaTypeStr = json['media_type'] as String? ?? '';
    final mediaType = switch (mediaTypeStr) {
      'movie' => MediaType.movie,
      'tv' => MediaType.tv,
      _ => MediaType.unknown,
    };

    return TmdbMedia(
      id: json['id'] as int? ?? 0,
      adult: json['adult'] as bool? ?? false,
      mediaType: mediaType,
      genreIds:
          (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      popularity: (json['popularity'] as num? ?? 0).toDouble(),
      voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
      voteCount: json['vote_count'] as int? ?? 0,
      overview: json['overview'] as String? ?? '',
      backdropPath: json['backdrop_path'] as String?,
      posterPath: json['poster_path'] as String?,
      originalLanguage: json['original_language'] as String?,
      // Movie fields
      title: json['title'] as String?,
      originalTitle: json['original_title'] as String?,
      releaseDate: json['release_date'] as String?,
      video: json['video'] as bool?,
      // TV fields
      name: json['name'] as String?,
      originalName: json['original_name'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      originCountry: (json['origin_country'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final mediaTypeStr = switch (mediaType) {
      MediaType.movie => 'movie',
      MediaType.tv => 'tv',
      MediaType.unknown => 'unknown',
    };

    return {
      'id': id,
      'adult': adult,
      'media_type': mediaTypeStr,
      'genre_ids': genreIds,
      'popularity': popularity,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'overview': overview,
      if (backdropPath != null) 'backdrop_path': backdropPath,
      if (posterPath != null) 'poster_path': posterPath,
      if (originalLanguage != null) 'original_language': originalLanguage,
      if (title != null) 'title': title,
      if (originalTitle != null) 'original_title': originalTitle,
      if (releaseDate != null) 'release_date': releaseDate,
      if (video != null) 'video': video,
      if (name != null) 'name': name,
      if (originalName != null) 'original_name': originalName,
      if (firstAirDate != null) 'first_air_date': firstAirDate,
      if (originCountry != null) 'origin_country': originCountry,
    };
  }

  TmdbMedia copyWith({
    int? id,
    bool? adult,
    MediaType? mediaType,
    List<int>? genreIds,
    double? popularity,
    double? voteAverage,
    int? voteCount,
    String? overview,
    String? backdropPath,
    String? posterPath,
    String? originalLanguage,
    String? title,
    String? originalTitle,
    String? releaseDate,
    bool? video,
    String? name,
    String? originalName,
    String? firstAirDate,
    List<String>? originCountry,
  }) {
    return TmdbMedia(
      id: id ?? this.id,
      adult: adult ?? this.adult,
      mediaType: mediaType ?? this.mediaType,
      genreIds: genreIds ?? this.genreIds,
      popularity: popularity ?? this.popularity,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      overview: overview ?? this.overview,
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      title: title ?? this.title,
      originalTitle: originalTitle ?? this.originalTitle,
      releaseDate: releaseDate ?? this.releaseDate,
      video: video ?? this.video,
      name: name ?? this.name,
      originalName: originalName ?? this.originalName,
      firstAirDate: firstAirDate ?? this.firstAirDate,
      originCountry: originCountry ?? this.originCountry,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TmdbMedia && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'TmdbMedia(id: $id, type: $mediaType, title: $displayTitle)';

  bool get isAnime =>
      genreIds.contains(16) && (originCountry?.contains('JP') ?? false);
}

class BelongsToCollection {
  final int id;
  final String name;
  final String? posterPath;
  final String? backdropPath;

  const BelongsToCollection({
    required this.id,
    required this.name,
    this.posterPath,
    this.backdropPath,
  });

  factory BelongsToCollection.fromJson(Map<String, dynamic> json) =>
      BelongsToCollection(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (posterPath != null) 'poster_path': posterPath,
    if (backdropPath != null) 'backdrop_path': backdropPath,
  };
}

class Genre {
  final int id;
  final String name;

  const Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) =>
      Genre(id: json['id'] as int, name: json['name'] as String);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class ProductionCompany {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  const ProductionCompany({
    required this.id,
    this.logoPath,
    required this.name,
    required this.originCountry,
  });

  String? get logoUrl =>
      logoPath != null ? 'https://image.tmdb.org/t/p/w200$logoPath' : null;

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      ProductionCompany(
        id: json['id'] as int,
        logoPath: json['logo_path'] as String?,
        name: json['name'] as String? ?? '',
        originCountry: json['origin_country'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (logoPath != null) 'logo_path': logoPath,
    'name': name,
    'origin_country': originCountry,
  };
}

class ProductionCountry {
  final String iso31661;
  final String name;

  const ProductionCountry({required this.iso31661, required this.name});

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      ProductionCountry(
        iso31661: json['iso_3166_1'] as String? ?? '',
        name: json['name'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'iso_3166_1': iso31661, 'name': name};
}

class SpokenLanguage {
  final String englishName;
  final String iso6391;
  final String name;

  const SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
    englishName: json['english_name'] as String? ?? '',
    iso6391: json['iso_639_1'] as String? ?? '',
    name: json['name'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'english_name': englishName,
    'iso_639_1': iso6391,
    'name': name,
  };
}

class Episode {
  final int id;
  final String name;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final String airDate;
  final int episodeNumber;
  final String productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;

  const Episode({
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.airDate,
    required this.episodeNumber,
    required this.productionCode,
    this.runtime,
    required this.seasonNumber,
    required this.showId,
    this.stillPath,
  });

  String? get stillUrl =>
      stillPath != null ? 'https://image.tmdb.org/t/p/w300$stillPath' : null;

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    overview: json['overview'] as String? ?? '',
    voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
    voteCount: json['vote_count'] as int? ?? 0,
    airDate: json['air_date'] as String? ?? '',
    episodeNumber: json['episode_number'] as int? ?? 0,
    productionCode: json['production_code'] as String? ?? '',
    runtime: json['runtime'] as int?,
    seasonNumber: json['season_number'] as int? ?? 0,
    showId: json['show_id'] as int? ?? 0,
    stillPath: json['still_path'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'overview': overview,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'air_date': airDate,
    'episode_number': episodeNumber,
    'production_code': productionCode,
    if (runtime != null) 'runtime': runtime,
    'season_number': seasonNumber,
    'show_id': showId,
    if (stillPath != null) 'still_path': stillPath,
  };
}

class Network {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  const Network({
    required this.id,
    this.logoPath,
    required this.name,
    required this.originCountry,
  });

  String? get logoUrl =>
      logoPath != null ? 'https://image.tmdb.org/t/p/w200$logoPath' : null;

  factory Network.fromJson(Map<String, dynamic> json) => Network(
    id: json['id'] as int,
    logoPath: json['logo_path'] as String?,
    name: json['name'] as String? ?? '',
    originCountry: json['origin_country'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (logoPath != null) 'logo_path': logoPath,
    'name': name,
    'origin_country': originCountry,
  };
}

class Season {
  final String? airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  const Season({
    this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w300$posterPath' : null;

  bool get isSpecials => seasonNumber == 0;

  factory Season.fromJson(Map<String, dynamic> json) => Season(
    airDate: json['air_date'] as String?,
    episodeCount: json['episode_count'] as int? ?? 0,
    id: json['id'] as int? ?? 0,
    name: json['name'] as String? ?? '',
    overview: json['overview'] as String? ?? '',
    posterPath: json['poster_path'] as String?,
    seasonNumber: json['season_number'] as int? ?? 0,
    voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    if (airDate != null) 'air_date': airDate,
    'episode_count': episodeCount,
    'id': id,
    'name': name,
    'overview': overview,
    if (posterPath != null) 'poster_path': posterPath,
    'season_number': seasonNumber,
    'vote_average': voteAverage,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Season && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class SeasonDetail {
  final String internalId;
  final String? airDate;
  final List<Episode> episodes;
  final String name;
  final String overview;
  final int id;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  const SeasonDetail({
    required this.internalId,
    this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.id,
    this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  factory SeasonDetail.fromJson(Map<String, dynamic> json) {
    return SeasonDetail(
      internalId: json['_id'] as String? ?? '',
      airDate: json['air_date'] as String?,
      episodes:
          (json['episodes'] as List<dynamic>?)
              ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      posterPath: json['poster_path'] as String?,
      seasonNumber: json['season_number'] as int? ?? 0,
      voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
    );
  }
}

class CreditResponse {
  final int id;
  final List<Cast> cast;
  final List<Crew> crew;

  const CreditResponse({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory CreditResponse.fromJson(Map<String, dynamic> json) {
    return CreditResponse(
      id: json['id'] as int,
      cast:
          (json['cast'] as List<dynamic>?)
              ?.map((e) => Cast.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      crew:
          (json['crew'] as List<dynamic>?)
              ?.map((e) => Crew.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Cast {
  final int id;
  final String name;
  final String originalName;
  final String character;
  final String? profilePath;
  final int order;

  const Cast({
    required this.id,
    required this.name,
    required this.originalName,
    required this.character,
    this.profilePath,
    required this.order,
  });

  String? get profileUrl => profilePath != null
      ? 'https://image.tmdb.org/t/p/w185$profilePath'
      : null;

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      character: json['character'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }
}

class Crew {
  final int id;
  final String name;
  final String department;
  final String job;
  final String? profilePath;

  const Crew({
    required this.id,
    required this.name,
    required this.department,
    required this.job,
    this.profilePath,
  });

  String? get profileUrl => profilePath != null
      ? 'https://image.tmdb.org/t/p/w185$profilePath'
      : null;

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      department: json['department'] as String? ?? '',
      job: json['job'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
    );
  }
}

class AlternativeTitle {
  final String title;
  final String? type;

  const AlternativeTitle({required this.title, this.type});

  factory AlternativeTitle.fromJson(Map<String, dynamic> json) {
    return AlternativeTitle(
      title: (json['title'] ?? json['name']) as String? ?? '',
      type: json['type'] as String?,
    );
  }
}

class ReleaseInfo {
  final String? iso31661;
  final List<ReleaseDate>? releaseDates; // For movies
  final String? rating; // For TV

  const ReleaseInfo({this.iso31661, this.releaseDates, this.rating});

  factory ReleaseInfo.fromJson(Map<String, dynamic> json) {
    return ReleaseInfo(
      iso31661: json['iso_3166_1'] as String?,
      rating: json['rating'] as String?,
      releaseDates: (json['release_dates'] as List<dynamic>?)
          ?.map((e) => ReleaseDate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ReleaseDate {
  final String releaseDate;
  final String? certification;
  final int type;

  const ReleaseDate({
    required this.releaseDate,
    this.certification,
    required this.type,
  });

  factory ReleaseDate.fromJson(Map<String, dynamic> json) {
    return ReleaseDate(
      releaseDate: json['release_date'] as String? ?? '',
      certification: json['certification'] as String?,
      type: json['type'] as int? ?? 0,
    );
  }
}

class PopularMoviesResponse {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  PopularMoviesResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory PopularMoviesResponse.fromJson(Map<String, dynamic> json) {
    return PopularMoviesResponse(
      page: json['page'] as int,
      results: (json['results'] as List<dynamic>)
          .map((item) => Movie.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'results': results.map((e) => e.toJson()).toList(),
    'total_pages': totalPages,
    'total_results': totalResults,
  };
}

class Movie {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  String? get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : null;

  String get year =>
      releaseDate.isNotEmpty ? releaseDate.substring(0, 4) : 'N/A';

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      adult: json['adult'] as bool,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      id: json['id'] as int,
      originalLanguage: json['original_language'] as String,
      originalTitle: json['original_title'] as String,
      overview: json['overview'] as String,
      popularity: (json['popularity'] as num).toDouble(),
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String? ?? '',
      title: json['title'] as String,
      video: json['video'] as bool,
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'adult': adult,
    if (backdropPath != null) 'backdrop_path': backdropPath,
    'genre_ids': genreIds,
    'id': id,
    'original_language': originalLanguage,
    'original_title': originalTitle,
    'overview': overview,
    'popularity': popularity,
    if (posterPath != null) 'poster_path': posterPath,
    'release_date': releaseDate,
    'title': title,
    'video': video,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };
}

class MovieDetail {
  final bool adult;
  final String? backdropPath;
  final BelongsToCollection? belongsToCollection;
  final int budget;
  final List<Genre> genres;
  final String? homepage;
  final int id;
  final String? imdbId;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final String releaseDate;
  final int revenue;
  final int runtime;
  final List<SpokenLanguage> spokenLanguages;
  final String status;
  final String? tagline;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  MovieDetail({
    required this.adult,
    this.backdropPath,
    this.belongsToCollection,
    required this.budget,
    required this.genres,
    this.homepage,
    required this.id,
    this.imdbId,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.spokenLanguages,
    required this.status,
    this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  String? get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : null;

  String get year =>
      releaseDate.isNotEmpty ? releaseDate.substring(0, 4) : 'N/A';

  String get runtimeFormatted {
    final h = runtime ~/ 60;
    final m = runtime % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  List<String> get genreNames => genres.map((g) => g.name).toList();

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      adult: json['adult'] as bool,
      backdropPath: json['backdrop_path'] as String?,
      belongsToCollection: json['belongs_to_collection'] != null
          ? BelongsToCollection.fromJson(
              json['belongs_to_collection'] as Map<String, dynamic>,
            )
          : null,
      budget: json['budget'] as int,
      genres: (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      homepage: json['homepage'] as String?,
      id: json['id'] as int,
      imdbId: json['imdb_id'] as String?,
      originalLanguage: json['original_language'] as String,
      originalTitle: json['original_title'] as String,
      overview: json['overview'] as String,
      popularity: (json['popularity'] as num).toDouble(),
      posterPath: json['poster_path'] as String?,
      productionCompanies: (json['production_companies'] as List<dynamic>)
          .map((e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
          .toList(),
      productionCountries: (json['production_countries'] as List<dynamic>)
          .map((e) => ProductionCountry.fromJson(e as Map<String, dynamic>))
          .toList(),
      releaseDate: json['release_date'] as String? ?? '',
      revenue: json['revenue'] as int,
      runtime: json['runtime'] as int,
      spokenLanguages: (json['spoken_languages'] as List<dynamic>)
          .map((e) => SpokenLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      tagline: json['tagline'] as String?,
      title: json['title'] as String,
      video: json['video'] as bool,
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'adult': adult,
    if (backdropPath != null) 'backdrop_path': backdropPath,
    'belongs_to_collection': belongsToCollection?.toJson(),
    'budget': budget,
    'genres': genres.map((e) => e.toJson()).toList(),
    if (homepage != null) 'homepage': homepage,
    'id': id,
    if (imdbId != null) 'imdb_id': imdbId,
    'original_language': originalLanguage,
    'original_title': originalTitle,
    'overview': overview,
    'popularity': popularity,
    if (posterPath != null) 'poster_path': posterPath,
    'production_companies': productionCompanies.map((e) => e.toJson()).toList(),
    'production_countries': productionCountries.map((e) => e.toJson()).toList(),
    'release_date': releaseDate,
    'revenue': revenue,
    'runtime': runtime,
    'spoken_languages': spokenLanguages.map((e) => e.toJson()).toList(),
    'status': status,
    if (tagline != null) 'tagline': tagline,
    'title': title,
    'video': video,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };
}

class TopRatedTvResponse {
  final int page;
  final List<TvShow> results;
  final int totalPages;
  final int totalResults;

  TopRatedTvResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TopRatedTvResponse.fromJson(Map<String, dynamic> json) {
    return TopRatedTvResponse(
      page: json['page'] as int,
      results: (json['results'] as List<dynamic>)
          .map((item) => TvShow.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'results': results.map((e) => e.toJson()).toList(),
    'total_pages': totalPages,
    'total_results': totalResults,
  };
}

class TvShow {
  final String? backdropPath;
  final String firstAirDate;
  final List<int> genreIds;
  final int id;
  final String name;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;

  TvShow({
    this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  String? get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : null;

  String get year =>
      firstAirDate.isNotEmpty ? firstAirDate.substring(0, 4) : 'N/A';

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      backdropPath: json['backdrop_path'] as String?,
      firstAirDate: json['first_air_date'] as String? ?? '',
      genreIds: (json['genre_ids'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      id: json['id'] as int,
      name: json['name'] as String,
      originCountry: (json['origin_country'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      originalLanguage: json['original_language'] as String,
      originalName: json['original_name'] as String,
      overview: json['overview'] as String,
      popularity: (json['popularity'] as num).toDouble(),
      posterPath: json['poster_path'] as String?,
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    if (backdropPath != null) 'backdrop_path': backdropPath,
    'first_air_date': firstAirDate,
    'genre_ids': genreIds,
    'id': id,
    'name': name,
    'origin_country': originCountry,
    'original_language': originalLanguage,
    'original_name': originalName,
    'overview': overview,
    'popularity': popularity,
    if (posterPath != null) 'poster_path': posterPath,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };
}

class TvShowDetail {
  final bool adult;
  final String? backdropPath;
  final List<CreatedBy> createdBy;
  final List<int> episodeRunTime;
  final String firstAirDate;
  final List<Genre> genres;
  final String? homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final String lastAirDate;
  final Episode? lastEpisodeToAir;
  final String name;
  final Episode? nextEpisodeToAir;
  final List<Network> networks;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final List<Season> seasons;
  final List<SpokenLanguage> spokenLanguages;
  final String status;
  final String? tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  TvShowDetail({
    required this.adult,
    this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    this.lastEpisodeToAir,
    required this.name,
    this.nextEpisodeToAir,
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.seasons,
    required this.spokenLanguages,
    required this.status,
    this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  String? get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : null;

  String get startYear =>
      firstAirDate.isNotEmpty ? firstAirDate.substring(0, 4) : 'N/A';

  String get endYear =>
      lastAirDate.isNotEmpty ? lastAirDate.substring(0, 4) : 'N/A';

  String get yearRange => inProduction ? '$startYear–' : '$startYear–$endYear';

  List<String> get genreNames => genres.map((g) => g.name).toList();

  List<Season> get regularSeasons =>
      seasons.where((s) => s.seasonNumber > 0).toList();

  factory TvShowDetail.fromJson(Map<String, dynamic> json) {
    return TvShowDetail(
      adult: json['adult'] as bool,
      backdropPath: json['backdrop_path'] as String?,
      createdBy: (json['created_by'] as List<dynamic>)
          .map((e) => CreatedBy.fromJson(e as Map<String, dynamic>))
          .toList(),
      episodeRunTime: (json['episode_run_time'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      firstAirDate: json['first_air_date'] as String? ?? '',
      genres: (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      homepage: json['homepage'] as String?,
      id: json['id'] as int,
      inProduction: json['in_production'] as bool,
      languages: (json['languages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastAirDate: json['last_air_date'] as String? ?? '',
      lastEpisodeToAir: json['last_episode_to_air'] != null
          ? Episode.fromJson(
              json['last_episode_to_air'] as Map<String, dynamic>,
            )
          : null,
      name: json['name'] as String,
      nextEpisodeToAir: json['next_episode_to_air'] != null
          ? Episode.fromJson(
              json['next_episode_to_air'] as Map<String, dynamic>,
            )
          : null,
      networks: (json['networks'] as List<dynamic>)
          .map((e) => Network.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberOfEpisodes: json['number_of_episodes'] as int,
      numberOfSeasons: json['number_of_seasons'] as int,
      originCountry: (json['origin_country'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      originalLanguage: json['original_language'] as String,
      originalName: json['original_name'] as String,
      overview: json['overview'] as String,
      popularity: (json['popularity'] as num).toDouble(),
      posterPath: json['poster_path'] as String?,
      productionCompanies: (json['production_companies'] as List<dynamic>)
          .map((e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
          .toList(),
      productionCountries: (json['production_countries'] as List<dynamic>)
          .map((e) => ProductionCountry.fromJson(e as Map<String, dynamic>))
          .toList(),
      seasons: (json['seasons'] as List<dynamic>)
          .map((e) => Season.fromJson(e as Map<String, dynamic>))
          .toList(),
      spokenLanguages: (json['spoken_languages'] as List<dynamic>)
          .map((e) => SpokenLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      tagline: json['tagline'] as String?,
      type: json['type'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'adult': adult,
    if (backdropPath != null) 'backdrop_path': backdropPath,
    'created_by': createdBy.map((e) => e.toJson()).toList(),
    'episode_run_time': episodeRunTime,
    'first_air_date': firstAirDate,
    'genres': genres.map((e) => e.toJson()).toList(),
    if (homepage != null) 'homepage': homepage,
    'id': id,
    'in_production': inProduction,
    'languages': languages,
    'last_air_date': lastAirDate,
    'last_episode_to_air': lastEpisodeToAir?.toJson(),
    'name': name,
    'next_episode_to_air': nextEpisodeToAir?.toJson(),
    'networks': networks.map((e) => e.toJson()).toList(),
    'number_of_episodes': numberOfEpisodes,
    'number_of_seasons': numberOfSeasons,
    'origin_country': originCountry,
    'original_language': originalLanguage,
    'original_name': originalName,
    'overview': overview,
    'popularity': popularity,
    if (posterPath != null) 'poster_path': posterPath,
    'production_companies': productionCompanies.map((e) => e.toJson()).toList(),
    'production_countries': productionCountries.map((e) => e.toJson()).toList(),
    'seasons': seasons.map((e) => e.toJson()).toList(),
    'spoken_languages': spokenLanguages.map((e) => e.toJson()).toList(),
    'status': status,
    if (tagline != null) 'tagline': tagline,
    'type': type,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };
}

class CreatedBy {
  final int id;
  final String creditId;
  final String name;
  final int gender;
  final String? profilePath;

  CreatedBy({
    required this.id,
    required this.creditId,
    required this.name,
    required this.gender,
    this.profilePath,
  });

  String? get profileUrl => profilePath != null
      ? 'https://image.tmdb.org/t/p/w185$profilePath'
      : null;

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    id: json['id'] as int,
    creditId: json['credit_id'] as String,
    name: json['name'] as String,
    gender: json['gender'] as int,
    profilePath: json['profile_path'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'credit_id': creditId,
    'name': name,
    'gender': gender,
    if (profilePath != null) 'profile_path': profilePath,
  };
}

class Country {
  final String iso31661;
  final String englishName;
  final String nativeName;

  Country({
    required this.iso31661,
    required this.englishName,
    required this.nativeName,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    iso31661: json['iso_3166_1'] as String,
    englishName: json['english_name'] as String,
    nativeName: json['native_name'] as String,
  );

  Map<String, dynamic> toJson() => {
    'iso_3166_1': iso31661,
    'english_name': englishName,
    'native_name': nativeName,
  };
}

class Language {
  final String iso6391;
  final String englishName;
  final String name;

  Language({
    required this.iso6391,
    required this.englishName,
    required this.name,
  });

  String get displayName => name.isNotEmpty ? name : englishName;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    iso6391: json['iso_639_1'] as String? ?? '',
    englishName: json['english_name'] as String? ?? '',
    name: json['name'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'iso_639_1': iso6391,
    'english_name': englishName,
    'name': name,
  };
}

class GenreListResponse {
  final List<Genre> genres;

  GenreListResponse({required this.genres});

  factory GenreListResponse.fromJson(Map<String, dynamic> json) =>
      GenreListResponse(
        genres: (json['genres'] as List<dynamic>)
            .map((e) => Genre.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'genres': genres.map((e) => e.toJson()).toList(),
  };
}

class ProductionCompanyDetail {
  final String description;
  final String headquarters;
  final String? homepage;
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;
  final ParentCompany? parentCompany;

  ProductionCompanyDetail({
    required this.description,
    required this.headquarters,
    this.homepage,
    required this.id,
    this.logoPath,
    required this.name,
    required this.originCountry,
    this.parentCompany,
  });

  String? get logoUrl =>
      logoPath != null ? 'https://image.tmdb.org/t/p/w200$logoPath' : null;

  factory ProductionCompanyDetail.fromJson(Map<String, dynamic> json) =>
      ProductionCompanyDetail(
        description: json['description'] as String? ?? '',
        headquarters: json['headquarters'] as String? ?? '',
        homepage: json['homepage'] as String?,
        id: json['id'] as int? ?? 0,
        logoPath: json['logo_path'] as String?,
        name: json['name'] as String? ?? '',
        originCountry: json['origin_country'] as String? ?? '',
        parentCompany: json['parent_company'] != null
            ? ParentCompany.fromJson(
                json['parent_company'] as Map<String, dynamic>,
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
    'description': description,
    'headquarters': headquarters,
    if (homepage != null) 'homepage': homepage,
    'id': id,
    if (logoPath != null) 'logo_path': logoPath,
    'name': name,
    'origin_country': originCountry,
    'parent_company': parentCompany?.toJson(),
  };
}

class ParentCompany {
  final int id;
  final String name;
  final String? logoPath;

  ParentCompany({required this.id, required this.name, this.logoPath});

  String? get logoUrl =>
      logoPath != null ? 'https://image.tmdb.org/t/p/w200$logoPath' : null;

  factory ParentCompany.fromJson(Map<String, dynamic> json) => ParentCompany(
    id: json['id'] as int? ?? 0,
    name: json['name'] as String? ?? '',
    logoPath: json['logo_path'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (logoPath != null) 'logo_path': logoPath,
  };
}

class PersonDetails {
  final bool adult;
  final List<String> alsoKnownAs;
  final String biography;
  final String? birthday;
  final String? deathday;
  final int gender;
  final String? homepage;
  final int id;
  final String imdbId;
  final String knownForDepartment;
  final String name;
  final String placeOfBirth;
  final double popularity;
  final String? profilePath;

  PersonDetails({
    required this.adult,
    required this.alsoKnownAs,
    required this.biography,
    this.birthday,
    this.deathday,
    required this.gender,
    this.homepage,
    required this.id,
    required this.imdbId,
    required this.knownForDepartment,
    required this.name,
    required this.placeOfBirth,
    required this.popularity,
    this.profilePath,
  });

  factory PersonDetails.fromJson(Map<String, dynamic> json) {
    return PersonDetails(
      adult: json['adult'] as bool? ?? false,
      alsoKnownAs: List<String>.from(json['also_known_as'] ?? []),
      biography: json['biography'] as String? ?? '',
      birthday: json['birthday'] as String?,
      deathday: json['deathday'] as String?,
      gender: json['gender'] as int? ?? 0,
      homepage: json['homepage'] as String?,
      id: json['id'] as int? ?? 0,
      imdbId: json['imdb_id'] as String? ?? '',
      knownForDepartment: json['known_for_department'] as String? ?? '',
      name: json['name'] as String? ?? '',
      placeOfBirth: json['place_of_birth'] as String? ?? '',
      popularity: (json['popularity'] as num? ?? 0).toDouble(),
      profilePath: json['profile_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'also_known_as': alsoKnownAs,
      'biography': biography,
      'birthday': birthday,
      'deathday': deathday,
      'gender': gender,
      'homepage': homepage,
      'id': id,
      'imdb_id': imdbId,
      'known_for_department': knownForDepartment,
      'name': name,
      'place_of_birth': placeOfBirth,
      'popularity': popularity,
      'profile_path': profilePath,
    };
  }

  @override
  String toString() => 'PersonDetails(id: $id, name: $name)';
}

class PersonCredits {
  final int id;
  final List<CastCredit> cast;
  final List<CrewCredit> crew;

  PersonCredits({required this.id, required this.cast, required this.crew});

  factory PersonCredits.fromJson(Map<String, dynamic> json) {
    return PersonCredits(
      id: json['id'] as int,
      cast: (json['cast'] as List<dynamic>)
          .map((e) => CastCredit.fromJson(e as Map<String, dynamic>))
          .toList(),
      crew: (json['crew'] as List<dynamic>)
          .map((e) => CrewCredit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'cast': cast.map((e) => e.toJson()).toList(),
    'crew': crew.map((e) => e.toJson()).toList(),
  };
}

// Base class for shared fields between movie and TV credits
abstract class BaseCredit {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String? overview;
  final double popularity;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;
  final String character;
  final String creditId;
  final String mediaType;

  const BaseCredit({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    this.overview,
    required this.popularity,
    this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.character,
    required this.creditId,
    required this.mediaType,
  });
}

class MovieCastCredit extends CastCredit {
  final String? originalTitle;
  final String? releaseDate;
  final String? title;
  final bool video;
  final int order;

  const MovieCastCredit({
    required super.adult,
    super.backdropPath,
    required super.genreIds,
    required super.id,
    required super.originalLanguage,
    super.overview,
    required super.popularity,
    super.posterPath,
    required super.voteAverage,
    required super.voteCount,
    required super.character,
    required super.creditId,
    required super.mediaType,
    this.originalTitle,
    this.releaseDate,
    this.title,
    required this.video,
    required this.order,
  });

  factory MovieCastCredit.fromJson(Map<String, dynamic> json) {
    return MovieCastCredit(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      id: json['id'] as int? ?? 0,
      originalLanguage: json['original_language'] as String? ?? '',
      overview: json['overview'] as String?,
      popularity: (json['popularity'] as num? ?? 0).toDouble(),
      posterPath: json['poster_path'] as String?,
      voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
      voteCount: json['vote_count'] as int? ?? 0,
      character: json['character'] as String? ?? '',
      creditId: json['credit_id'] as String? ?? '',
      mediaType: json['media_type'] as String? ?? 'movie',
      originalTitle: json['original_title'] as String?,
      releaseDate: json['release_date'] as String?,
      title: json['title'] as String?,
      video: json['video'] as bool? ?? false,
      order: json['order'] as int? ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'adult': adult,
    'backdrop_path': backdropPath,
    'genre_ids': genreIds,
    'id': id,
    'original_language': originalLanguage,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'character': character,
    'credit_id': creditId,
    'media_type': mediaType,
    'original_title': originalTitle,
    'release_date': releaseDate,
    'title': title,
    'video': video,
    'order': order,
  };
}

class TvCastCredit extends CastCredit {
  final List<String> originCountry;
  final String? originalName;
  final String? firstAirDate;
  final String? name;
  final int episodeCount;

  const TvCastCredit({
    required super.adult,
    super.backdropPath,
    required super.genreIds,
    required super.id,
    required super.originalLanguage,
    super.overview,
    required super.popularity,
    super.posterPath,
    required super.voteAverage,
    required super.voteCount,
    required super.character,
    required super.creditId,
    required super.mediaType,
    required this.originCountry,
    this.originalName,
    this.firstAirDate,
    this.name,
    required this.episodeCount,
  });

  factory TvCastCredit.fromJson(Map<String, dynamic> json) {
    return TvCastCredit(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      id: json['id'] as int? ?? 0,
      originalLanguage: json['original_language'] as String? ?? '',
      overview: json['overview'] as String?,
      popularity: (json['popularity'] as num? ?? 0).toDouble(),
      posterPath: json['poster_path'] as String?,
      voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
      voteCount: json['vote_count'] as int? ?? 0,
      character: json['character'] as String? ?? '',
      creditId: json['credit_id'] as String? ?? '',
      mediaType: json['media_type'] as String? ?? 'tv',
      originCountry: List<String>.from(json['origin_country'] ?? []),
      originalName: json['original_name'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      name: json['name'] as String?,
      episodeCount: json['episode_count'] as int? ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'adult': adult,
    'backdrop_path': backdropPath,
    'genre_ids': genreIds,
    'id': id,
    'original_language': originalLanguage,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'character': character,
    'credit_id': creditId,
    'media_type': mediaType,
    'origin_country': originCountry,
    'original_name': originalName,
    'first_air_date': firstAirDate,
    'name': name,
    'episode_count': episodeCount,
  };
}

// Sealed union for crew (movie or tv)
sealed class CrewCredit extends BaseCredit {
  final String department;
  final String job;

  const CrewCredit({
    required super.adult,
    super.backdropPath,
    required super.genreIds,
    required super.id,
    required super.originalLanguage,
    super.overview,
    required super.popularity,
    super.posterPath,
    required super.voteAverage,
    required super.voteCount,
    required super.character,
    required super.creditId,
    required super.mediaType,
    required this.department,
    required this.job,
  });

  factory CrewCredit.fromJson(Map<String, dynamic> json) {
    final mediaType = json['media_type'] as String? ?? '';
    return switch (mediaType) {
      'movie' => MovieCrewCredit.fromJson(json),
      'tv' => TvCrewCredit.fromJson(json),
      _ => throw ArgumentError('Unknown media_type: $mediaType'),
    };
  }

  Map<String, dynamic> toJson();
}

class MovieCrewCredit extends CrewCredit {
  final String? originalTitle;
  final String? releaseDate;
  final String? title;
  final bool video;

  MovieCrewCredit({
    required super.adult,
    super.backdropPath,
    required super.genreIds,
    required super.id,
    required super.originalLanguage,
    this.originalTitle,
    super.overview,
    required super.popularity,
    super.posterPath,
    this.releaseDate,
    this.title,
    required this.video,
    required super.voteAverage,
    required super.voteCount,
    required super.character,
    required super.creditId,
    required super.department,
    required super.job,
    required super.mediaType,
  });

  factory MovieCrewCredit.fromJson(Map<String, dynamic> json) {
    return MovieCrewCredit(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      id: json['id'] as int? ?? 0,
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      popularity: (json['popularity'] as num? ?? 0).toDouble(),
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      title: json['title'] as String?,
      video: json['video'] as bool? ?? false,
      voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
      voteCount: json['vote_count'] as int? ?? 0,
      creditId: json['credit_id'] as String? ?? '',
      department: json['department'] as String? ?? '',
      job: json['job'] as String? ?? '',
      mediaType: json['media_type'] as String? ?? 'movie',
      character: '', // Movie crew doesn't usually have a character
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'adult': adult,
    'backdrop_path': backdropPath,
    'genre_ids': genreIds,
    'id': id,
    'original_language': originalLanguage,
    'original_title': originalTitle,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'release_date': releaseDate,
    'title': title,
    'video': video,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'credit_id': creditId,
    'department': department,
    'job': job,
    'media_type': mediaType,
  };
}

class TvCrewCredit extends CrewCredit {
  final List<String> originCountry;
  final String? originalName;
  final String? firstAirDate;
  final String? name;
  final int episodeCount;

  TvCrewCredit({
    required super.adult,
    super.backdropPath,
    required super.genreIds,
    required super.id,
    required this.originCountry,
    required super.originalLanguage,
    this.originalName,
    super.overview,
    required super.popularity,
    super.posterPath,
    this.firstAirDate,
    this.name,
    required super.voteAverage,
    required super.voteCount,
    required super.creditId,
    required super.department,
    required this.episodeCount,
    required super.job,
    required super.mediaType,
    required super.character,
  });

  factory TvCrewCredit.fromJson(Map<String, dynamic> json) {
    return TvCrewCredit(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      id: json['id'] as int? ?? 0,
      originCountry: List<String>.from(json['origin_country'] ?? []),
      originalLanguage: json['original_language'] as String? ?? '',
      originalName: json['original_name'] as String?,
      overview: json['overview'] as String?,
      popularity: (json['popularity'] as num? ?? 0).toDouble(),
      posterPath: json['poster_path'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      name: json['name'] as String?,
      voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
      voteCount: json['vote_count'] as int? ?? 0,
      creditId: json['credit_id'] as String? ?? '',
      department: json['department'] as String? ?? '',
      episodeCount: json['episode_count'] as int? ?? 0,
      job: json['job'] as String? ?? '',
      mediaType: json['media_type'] as String? ?? 'tv',
      character: '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'adult': adult,
    'backdrop_path': backdropPath,
    'genre_ids': genreIds,
    'id': id,
    'origin_country': originCountry,
    'original_language': originalLanguage,
    'original_name': originalName,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'first_air_date': firstAirDate,
    'name': name,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'credit_id': creditId,
    'department': department,
    'episode_count': episodeCount,
    'job': job,
    'media_type': mediaType,
  };
}

// Sealed union for cast (movie or tv)
sealed class CastCredit extends BaseCredit {
  const CastCredit({
    required super.adult,
    super.backdropPath,
    required super.genreIds,
    required super.id,
    required super.originalLanguage,
    super.overview,
    required super.popularity,
    super.posterPath,
    required super.voteAverage,
    required super.voteCount,
    required super.character,
    required super.creditId,
    required super.mediaType,
  });

  factory CastCredit.fromJson(Map<String, dynamic> json) {
    final mediaType = json['media_type'] as String? ?? '';
    return switch (mediaType) {
      'movie' => MovieCastCredit.fromJson(json),
      'tv' => TvCastCredit.fromJson(json),
      _ => throw ArgumentError('Unknown media_type: $mediaType'),
    };
  }

  Map<String, dynamic> toJson();
}
