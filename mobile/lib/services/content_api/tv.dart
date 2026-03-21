import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/services/auth_service.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Required for JSON encoding/decoding

Future<TopRatedTvResponse> fetchTopShows({int page = 1}) async {
  final token = await AuthService().currentUser!.getIdToken();

  String apiUrl = serverUrl ?? 'http:localhost:3000';

  final response = await http.get(
    Uri.parse('$apiUrl/api/tv/top_rated?page=$page'),
    headers: {"Authorization": "Bearer $token"},
  );

  return TopRatedTvResponse.fromJson(jsonDecode(response.body));
}

Future<TvShowDetail> fetchTvShowById(int id) async {
  final token = await AuthService().currentUser!.getIdToken();

  String apiUrl = serverUrl ?? 'http:localhost:3000';

  final response = await http.get(
    Uri.parse('$apiUrl/api/tv/$id'),
    headers: {"Authorization": "Bearer $token"},
  );

  return TvShowDetail.fromJson(jsonDecode(response.body));
}

Future<CreditResponse> fetchTvCredits(int id) async {
  final token = await AuthService().currentUser!.getIdToken();
  String apiUrl = serverUrl ?? 'http:localhost:3000';
  final response = await http.get(
    Uri.parse('$apiUrl/api/tv/$id/credits'),
    headers: {"Authorization": "Bearer $token"},
  );
  return CreditResponse.fromJson(jsonDecode(response.body));
}

Future<List<AlternativeTitle>> fetchTvAlternativeTitles(int id) async {
  final token = await AuthService().currentUser!.getIdToken();
  String apiUrl = serverUrl ?? 'http:localhost:3000';
  final response = await http.get(
    Uri.parse('$apiUrl/api/tv/$id/alternative_titles'),
    headers: {"Authorization": "Bearer $token"},
  );
  final data = jsonDecode(response.body);
  return (data['results'] as List? ?? [])
      .map((e) => AlternativeTitle.fromJson(e))
      .toList();
}

Future<SeasonDetail> fetchSeasonDetails(int tvId, int seasonNumber) async {
  final token = await AuthService().currentUser!.getIdToken();
  String apiUrl = serverUrl ?? 'http:localhost:3000';
  final response = await http.get(
    Uri.parse('$apiUrl/api/tv/$tvId/season/$seasonNumber'),
    headers: {"Authorization": "Bearer $token"},
  );
  return SeasonDetail.fromJson(jsonDecode(response.body));
}
