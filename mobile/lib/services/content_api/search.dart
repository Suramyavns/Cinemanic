import 'dart:convert';

import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/services/auth_service.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:http/http.dart' as http;

Future<TmdbSearchResponse> searchContent(String query) async {
  String finalQuery = 'search/multi?query=$query&include_adult=false';

  final token = await AuthService().currentUser!.getIdToken();

  String apiUrl = serverUrl ?? 'http:localhost:3000';

  final response = await http.get(
    Uri.parse('$apiUrl/api/$finalQuery'),
    headers: {"Authorization": "Bearer $token"},
  );

  TmdbSearchResponse searchResults = TmdbSearchResponse.fromJson(
    jsonDecode(response.body),
  );
  return searchResults;
}
