import 'dart:async';

import 'package:cinemanic/models/media_item.dart';
import 'package:cinemanic/models/tmdb_models.dart' hide MediaType;
import 'package:cinemanic/models/watch_history.dart';
import 'package:cinemanic/models/watchlist.dart';
import 'package:cinemanic/services/content_api/movies.dart';
import 'package:cinemanic/services/content_api/recommendations.dart';
import 'package:cinemanic/services/content_api/search.dart';
import 'package:cinemanic/services/content_api/tv.dart';
import 'package:cinemanic/services/content_api/trending.dart';
import 'package:cinemanic/screens/discover_results_screen.dart';
import 'package:cinemanic/screens/content_screen.dart';
import 'package:cinemanic/services/watch_history_api.dart';
import 'package:cinemanic/services/watchlist_api.dart';
import 'package:cinemanic/widgets/home_screen_widgets/content_row_widget.dart';
import 'package:cinemanic/widgets/reusable_widgets/search_bar_widget.dart';
import 'package:cinemanic/widgets/reusable_widgets/search_result_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TrendingDataClass trendingData;
  late TopRatedTvResponse topShowsData;
  late PopularMoviesResponse popularMoviesData;
  late List<WatchHistoryItem> watchHistoryData;
  late List<WatchList> watchListData;
  late List<MediaItem> recommendationsData;
  late String lastWatchedTitle;
  bool isLoading = true;

  // Search state
  Timer? _debounce;
  List<TmdbMedia> _searchResults = [];
  bool _isSearching = false;
  String _currentQuery = '';

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      final results = await Future.wait([
        fetchTrending(),
        fetchTopShows(),
        fetchPopularMovies(),
        fetchWatchHistory(),
        getWatchList(),
      ]);

      final trending = results[0] as TrendingDataClass;
      final topShows = results[1] as TopRatedTvResponse;
      final popularMovies = results[2] as PopularMoviesResponse;
      final history = results[3] as List<WatchHistoryItem>;
      final watchList = results[4] as List<WatchList>;

      final lastWatchedItem = history.isNotEmpty ? history.first : null;
      List<MediaItem> recommendations = [];

      if (lastWatchedItem != null) {
        recommendations = lastWatchedItem.type == 'movie'
            ? await getRecommendedMovie(lastWatchedItem.id)
            : await getRecommendedTv(lastWatchedItem.id);
      }

      debugPrint(recommendations.toString());

      if (mounted) {
        setState(() {
          trendingData = trending;
          topShowsData = topShows;
          popularMoviesData = popularMovies;
          watchHistoryData = history;
          lastWatchedTitle = lastWatchedItem?.title ?? '';
          recommendationsData = recommendations;
          watchListData = watchList;
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle error so isLoading doesn't spin forever
      debugPrint(e.toString());
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
          _currentQuery = '';
        });
        return;
      }

      setState(() {
        _isSearching = true;
        _currentQuery = query;
      });

      try {
        final results = await searchContent(query);
        if (mounted && _currentQuery == query) {
          setState(() {
            _searchResults = results.results
                .where((item) => item.mediaType.name != 'unknown')
                .toList();

            _searchResults.sort((a, b) => b.popularity.compareTo(a.popularity));
            _isSearching = false;
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Search error: $e');
        }
        if (mounted) {
          setState(() {
            _isSearching = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isLoading = true;
          });
          await loadData();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SearchBarWidget(onChanged: _onSearchChanged),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: isLoading
                        ? const LinearProgressIndicator()
                        : Column(
                            children: [
                              if (watchHistoryData.isNotEmpty)
                                ContentRowWidget(
                                  title: 'Continue Watching',
                                  data: watchHistoryData,
                                  mediaType: 'history',
                                  onReturn: loadData,
                                ),

                              if (recommendationsData.isNotEmpty)
                                ContentRowWidget(
                                  title: 'You might like these',
                                  data: recommendationsData,
                                  mediaType: 'recommendations',
                                  onReturn: loadData,
                                ),
                              ContentRowWidget(
                                title: 'Trending',
                                data: trendingData,
                                mediaType: 'trending',
                                onReturn: loadData,
                              ),
                              if (watchListData.isNotEmpty)
                                ContentRowWidget(
                                  title: 'Watchlist',
                                  data: watchListData,
                                  mediaType: 'watchlist',
                                  onReturn: loadData,
                                ),
                              ContentRowWidget(
                                title: 'Popular Movies',
                                data: popularMoviesData,
                                mediaType: 'movie',
                                onReturn: loadData,
                                onViewMore: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DiscoverResultsScreen(
                                            title: 'Popular Movies',
                                            fetchFunction: (page) =>
                                                fetchPopularMovies(page: page),
                                            mediaType: 'movie',
                                          ),
                                    ),
                                  );
                                },
                              ),
                              ContentRowWidget(
                                title: 'Top Rated Shows',
                                data: topShowsData,
                                mediaType: 'tv',
                                onReturn: loadData,
                                onViewMore: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DiscoverResultsScreen(
                                            title: 'Top Rated Shows',
                                            fetchFunction: (page) =>
                                                fetchTopShows(page: page),
                                            mediaType: 'tv',
                                          ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 12),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            if (_currentQuery.isNotEmpty)
              Positioned(
                top: 60, // Positioned below the search bar
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: _isSearching
                      ? const Center(child: CircularProgressIndicator())
                      : _searchResults.isEmpty
                      ? const Center(child: Text('No results found'))
                      : ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: _searchResults.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final item = _searchResults[index];
                            return SearchResultCard(
                              item: item,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContentScreen(
                                      contentId: item.id,
                                      mediaType: item.mediaType.name,
                                    ),
                                  ),
                                );
                                loadData();
                              },
                            );
                          },
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
