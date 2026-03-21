import 'package:cinemanic/utils/constants.dart';

Future<String> fetchVideoPlayer(String id, String token, {int? startAt, bool isAnime = false}) async {
  String apiUrl = serverUrl ?? 'http://localhost:3000';

  String url = "$apiUrl/$id?token=${Uri.encodeComponent(token)}&isAnime=$isAnime";
  if (startAt != null) {
    url += "&startAt=$startAt";
  }
  return url;
}
