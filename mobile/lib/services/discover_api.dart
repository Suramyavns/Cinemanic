import 'dart:convert';

import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/services/auth_service.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:http/http.dart' as http;

Future<TmdbSearchResponse> discoverMoviesByProductionCompany(
  String companyId, {
  int page = 1,
}) async {
  final token = await AuthService().currentUser?.getIdToken();

  String apiUrl = serverUrl ?? 'http://localhost:3000';

  final response = await http.get(
    Uri.parse(
      '$apiUrl/api/discover/movie?sort_by=popularity.desc&with_companies=$companyId&page=$page',
    ),
    headers: {"Authorization": "Bearer $token"},
  );

  return TmdbSearchResponse.fromJson(jsonDecode(response.body));
}

Future<TmdbSearchResponse> discoverTVByProductionCompany(
  String companyId, {
  int page = 1,
}) async {
  final token = await AuthService().currentUser?.getIdToken();

  String apiUrl = serverUrl ?? 'http://localhost:3000';

  final response = await http.get(
    Uri.parse(
      '$apiUrl/api/discover/tv?sort_by=popularity.desc&with_companies=$companyId&page=$page',
    ),
    headers: {"Authorization": "Bearer $token"},
  );

  return TmdbSearchResponse.fromJson(jsonDecode(response.body));
}

Future<TmdbSearchResponse> discoverMoviesByGenre(String genreId, {int page = 1}) async {
  final token = await AuthService().currentUser?.getIdToken();

  String apiUrl = serverUrl ?? 'http://localhost:3000';

  final response = await http.get(
    Uri.parse(
      '$apiUrl/api/discover/movie?sort_by=popularity.desc&with_genres=$genreId&page=$page',
    ),
    headers: {"Authorization": "Bearer $token"},
  );

  return TmdbSearchResponse.fromJson(jsonDecode(response.body));
}

Future<TmdbSearchResponse> discoverTVByGenre(String genreId, {int page = 1}) async {
  final token = await AuthService().currentUser?.getIdToken();

  String apiUrl = serverUrl ?? 'http://localhost:3000';

  final response = await http.get(
    Uri.parse(
      '$apiUrl/api/discover/tv?sort_by=popularity.desc&with_genres=$genreId&page=$page',
    ),
    headers: {"Authorization": "Bearer $token"},
  );

  return TmdbSearchResponse.fromJson(jsonDecode(response.body));
}
