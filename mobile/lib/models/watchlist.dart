class WatchList {
  final int mediaId;
  final String type; // 'movie' or 'tv'
  final String title;
  final String? posterPath;
  final String? backdropPath;

  const WatchList({
    required this.mediaId,
    required this.type,
    required this.title,
    this.posterPath,
    this.backdropPath,
  });

  factory WatchList.fromJson(Map<String, dynamic> json) {
    return WatchList(
      mediaId: (json['mediaId'] as num? ?? 0).toInt(),
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      posterPath: json['posterPath'] as String?,
      backdropPath: json['backdropPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'media_id': mediaId,
      'type': type,
      'title': title,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
    };
  }
}
