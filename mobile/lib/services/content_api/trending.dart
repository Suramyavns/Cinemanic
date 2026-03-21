import 'package:cinemanic/models/media_item.dart';
import 'package:cinemanic/services/auth_service.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Required for JSON encoding/decoding

Future<TrendingDataClass> fetchTrending() async {
  final token = await AuthService().currentUser!.getIdToken();

  String apiUrl = serverUrl ?? 'http:localhost:3000';

  final response = await http.get(
    Uri.parse('$apiUrl/api/trending/all/week'),
    headers: {"Authorization": "Bearer $token"},
  );

  return TrendingDataClass.fromJson(jsonDecode(response.body));
}
