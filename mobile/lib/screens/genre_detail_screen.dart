import 'package:cinemanic/services/discover_api.dart';
import 'package:cinemanic/widgets/reusable_widgets/discovery_tabs_widget.dart';
import 'package:cinemanic/widgets/theme_switcher_widget.dart';
import 'package:flutter/material.dart';

class GenreDetailScreen extends StatelessWidget {
  final int genreId;
  final String genreName;

  const GenreDetailScreen({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(genreName),
          actions: [const ThemeSwitcherWidget()],
        ),
        body: DiscoveryTabsWidget(
          movieFuture: discoverMoviesByGenre(genreId.toString()),
          tvFuture: discoverTVByGenre(genreId.toString()),
        ),
      ),
    );
  }
}
