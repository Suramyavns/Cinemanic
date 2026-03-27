class WatchHistoryItem {
  final int id;
  final String type;
  final String title;
  final String posterPath;

  WatchHistoryItem({
    required this.id,
    required this.type,
    required this.title,
    required this.posterPath,
  });

  factory WatchHistoryItem.fromJson(Map<String, dynamic> json) {
    return WatchHistoryItem(
      id: (json['mediaId'] as num? ?? 0).toInt(),
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      posterPath: json['posterPath'] as String? ?? '',
    );
  }
}
