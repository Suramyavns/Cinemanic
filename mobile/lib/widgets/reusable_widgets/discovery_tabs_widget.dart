import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/widgets/reusable_widgets/content_grid_widget.dart';
import 'package:flutter/material.dart';

class DiscoveryTabsWidget extends StatelessWidget {
  final Future<TmdbSearchResponse> movieFuture;
  final Future<TmdbSearchResponse> tvFuture;
  final Widget? header;

  const DiscoveryTabsWidget({
    super.key,
    required this.movieFuture,
    required this.tvFuture,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          if (header != null) header!,
          const TabBar(
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'TV Shows'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildDiscoveryGrid(movieFuture, 'movie'),
                _buildDiscoveryGrid(tvFuture, 'tv'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveryGrid(Future<TmdbSearchResponse> future, String type) {
    return FutureBuilder<TmdbSearchResponse>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No content found'));
        }

        return ContentGridWidget(
          items: snapshot.data!.results,
          mediaType: type,
        );
      },
    );
  }
}
