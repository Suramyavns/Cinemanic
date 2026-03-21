import 'dart:convert';

import 'package:cinemanic/models/watchlist.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<WatchList>> getWatchList() async {
  final token = await FirebaseAuth.instance.currentUser?.getIdToken();
  if (token != null) {
    final apiUrl = serverUrl;
    final response = await http.get(
      Uri.parse('$apiUrl/api/watchlist'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = jsonDecode(response.body);
      debugPrint('getWatchList body: ${response.body}');
      return (data as List).map((item) => WatchList.fromJson(item)).toList();
    }
  }
  return [];
}

Future<bool> isInWatchlist(int mediaId) async {
  List<WatchList> data = await getWatchList();
  debugPrint('isInWatchlist data: $data');
  debugPrint('isInWatchlist mediaId: $mediaId');
  return data.any((element) => element.mediaId == mediaId);
}

Future<void> addToWatchList(WatchList watchList) async {
  final token = await FirebaseAuth.instance.currentUser?.getIdToken();
  if (token != null) {
    final apiUrl = serverUrl;
    final response = await http.post(
      Uri.parse('$apiUrl/api/watchlist'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mediaData': {
          '${watchList.mediaId}': {
            'id': watchList.mediaId,
            'type': watchList.type,
            'title': watchList.title,
            'poster_path': watchList.posterPath,
            'backdrop_path': watchList.backdropPath,
          },
        },
      }),
    );
    debugPrint('addToWatchList status: ${response.statusCode}');
    debugPrint('addToWatchList body: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to add watchlist: ${response.body}');
    }
  }
}

Future<void> deleteFromWatchList(WatchList watchList) async {
  final token = await FirebaseAuth.instance.currentUser?.getIdToken();
  if (token != null) {
    final apiUrl = serverUrl;
    final response = await http.delete(
      Uri.parse('$apiUrl/api/watchlist'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mediaData': {
          '${watchList.mediaId}': {'id': watchList.mediaId},
        },
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete watchlist');
    }
  }
}
