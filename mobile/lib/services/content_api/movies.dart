import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/services/auth_service.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Required for JSON encoding/decoding

Future<PopularMoviesResponse> fetchPopularMovies({int page = 1}) async {
  final token = await AuthService().currentUser!.getIdToken();

  String apiUrl = serverUrl ?? 'http:localhost:3000';

  final response = await http.get(
    Uri.parse('$apiUrl/api/movie/top_rated?page=$page'),
    headers: {"Authorization": "Bearer $token"},
  );

  return PopularMoviesResponse.fromJson(jsonDecode(response.body));
}

Future<MovieDetail> fetchMovieById(int id) async {
  final token = await AuthService().currentUser!.getIdToken();

  String apiUrl = serverUrl ?? 'http:localhost:3000';

  final response = await http.get(
    Uri.parse('$apiUrl/api/movie/$id'),
    headers: {"Authorization": "Bearer $token"},
  );

  return MovieDetail.fromJson(jsonDecode(response.body));
}

Future<CreditResponse> fetchMovieCredits(int id) async {
  final token = await AuthService().currentUser!.getIdToken();
  String apiUrl = serverUrl ?? 'http:localhost:3000';
  final response = await http.get(
    Uri.parse('$apiUrl/api/movie/$id/credits'),
    headers: {"Authorization": "Bearer $token"},
  );
  return CreditResponse.fromJson(jsonDecode(response.body));
}

Future<List<AlternativeTitle>> fetchMovieAlternativeTitles(int id) async {
  final token = await AuthService().currentUser!.getIdToken();
  String apiUrl = serverUrl ?? 'http:localhost:3000';
  final response = await http.get(
    Uri.parse('$apiUrl/api/movie/$id/alternative_titles'),
    headers: {"Authorization": "Bearer $token"},
  );
  final data = jsonDecode(response.body);
  return (data['titles'] as List? ?? [])
      .map((e) => AlternativeTitle.fromJson(e))
      .toList();
}

Future<List<ReleaseInfo>> fetchMovieReleaseInfo(int id) async {
  final token = await AuthService().currentUser!.getIdToken();
  String apiUrl = serverUrl ?? 'http:localhost:3000';
  final response = await http.get(
    Uri.parse('$apiUrl/api/movie/$id/release_dates'),
    headers: {"Authorization": "Bearer $token"},
  );
  final data = jsonDecode(response.body);
  return (data['results'] as List? ?? [])
      .map((e) => ReleaseInfo.fromJson(e))
      .toList();
}
