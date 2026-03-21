import 'dart:convert';

import 'package:cinemanic/models/watch_history.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<WatchHistoryItem>> fetchWatchHistory() async {
  try {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token != null) {
      final apiUrl = serverUrl;
      final response = await http.get(
        Uri.parse('$apiUrl/api/watch/history'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((x) => WatchHistoryItem.fromJson(x)).toList();
      }
    }
  } catch (e) {
    debugPrint('Failed to load history: $e');
  }
  return [];
}

Future<Map<String, dynamic>?> fetchWatchProgress(int mediaId) async {
  try {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token != null) {
      final apiUrl = serverUrl;
      final response = await http.get(
        Uri.parse('$apiUrl/api/watch/progress?mediaId=$mediaId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200 &&
          response.body.isNotEmpty &&
          response.body != 'null') {
        final data = jsonDecode(response.body);
        return data;
      }
    }
  } catch (e) {
    debugPrint('Failed to load progress: $e');
  }
  return null;
}
