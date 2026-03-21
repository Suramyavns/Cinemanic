import 'package:cinemanic/models/tmdb_models.dart';

bool isAnime(String mediaType, TvShowDetail? tvData) {
  if (mediaType != 'tv' || tvData == null) return false;
  final data = tvData;
  final hasAnimeGenre = data.genres.any(
    (g) => g.name.toLowerCase() == 'animation',
  );
  final isFromJapan = data.originCountry.contains('JP');
  return hasAnimeGenre && isFromJapan;
}
