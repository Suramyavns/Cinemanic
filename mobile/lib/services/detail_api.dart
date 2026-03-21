import 'dart:convert';

import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/services/auth_service.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:http/http.dart' as http;

Future<PersonDetails> getPersonDetails(String personId) async {
  final token = await AuthService().currentUser!.getIdToken();

  String apiUrl = serverUrl ?? 'http:localhost:3000';

  final response = await http.get(
    Uri.parse('$apiUrl/api/person/$personId'),
    headers: {"Authorization": "Bearer $token"},
  );

  return PersonDetails.fromJson(jsonDecode(response.body));
}

Future<PersonCredits> getPersonCreditDetails(String personId) async {
  final token = await AuthService().currentUser!.getIdToken();

  String apiUrl = serverUrl ?? 'http:localhost:3000';

  final response = await http.get(
    Uri.parse('$apiUrl/api/person/$personId/combined_credits'),
    headers: {"Authorization": "Bearer $token"},
  );

  return PersonCredits.fromJson(jsonDecode(response.body));
}

Future<ProductionCompanyDetail> getProductionCompanyDetails(
  String companyId,
) async {
  final token = await AuthService().currentUser!.getIdToken();

  String apiUrl = serverUrl ?? 'http:localhost:3000';

  final response = await http.get(
    Uri.parse('$apiUrl/api/company/$companyId'),
    headers: {"Authorization": "Bearer $token"},
  );

  return ProductionCompanyDetail.fromJson(jsonDecode(response.body));
}
