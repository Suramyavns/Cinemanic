import 'dart:convert';

import 'package:cinemanic/models/media_item.dart';
import 'package:cinemanic/services/auth_service.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:http/http.dart' as http;

Future<List<MediaItem>> getRecommendedMovie(int movieId) async {
  final token = await AuthService().currentUser!.getIdToken();
  final apiUrl = serverUrl ?? 'http://localhost:3000';

  final response = await http.get(
    Uri.parse('$apiUrl/api/movie/$movieId/recommendations'),
    headers: {"Authorization": "Bearer $token"},
  );

  final data = jsonDecode(response.body);
  final results = data['results'] as List<dynamic>? ?? [];
  return results
      .map((item) => MediaItem.fromJson(item as Map<String, dynamic>))
      .toList();
}

Future<List<MediaItem>> getRecommendedTv(int tvId) async {
  final token = await AuthService().currentUser!.getIdToken();
  final apiUrl = serverUrl ?? 'http://localhost:3000';

  final response = await http.get(
    Uri.parse('$apiUrl/api/tv/$tvId/recommendations'),
    headers: {"Authorization": "Bearer $token"},
  );

  final data = jsonDecode(response.body);
  final results = data['results'] as List<dynamic>? ?? [];
  return results
      .map((item) => MediaItem.fromJson(item as Map<String, dynamic>))
      .toList();
}
