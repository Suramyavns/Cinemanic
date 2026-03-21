import 'package:flutter_dotenv/flutter_dotenv.dart';

String imageUrlBuilder(String path) {
  return "${dotenv.env['IMAGE_BASE_URL']}$path";
}
