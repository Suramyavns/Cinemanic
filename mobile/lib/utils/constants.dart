import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String isDarkKey = 'isDark';
final serverUrl = dotenv.env['SERVER_URL'];

class KTextStyle extends TextStyle {
  static const TextStyle headingTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyTextStyle = TextStyle(fontSize: 14);

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}
