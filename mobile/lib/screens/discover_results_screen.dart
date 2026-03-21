import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/widgets/reusable_widgets/content_grid_widget.dart';
import 'package:cinemanic/widgets/theme_switcher_widget.dart';
import 'package:flutter/material.dart';

class DiscoverResultsScreen extends StatefulWidget {
  final String title;
  final String mediaType;
  final Future<dynamic> Function(int page) fetchFunction;

  const DiscoverResultsScreen({
    super.key,
    required this.title,
    required this.mediaType,
    required this.fetchFunction,
  });

  @override
  State<DiscoverResultsScreen> createState() => _DiscoverResultsScreenState();
}

class _DiscoverResultsScreenState extends State<DiscoverResultsScreen> {
  final List<TmdbMedia> _results = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMoreContent();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreContent();
    }
  }

  Future<void> _loadMoreContent() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await widget.fetchFunction(_currentPage);
      List<TmdbMedia> newItems = [];

      if (data is TmdbSearchResponse) {
        newItems = data.results;
      } else if (data is PopularMoviesResponse) {
        newItems = data.results.map((m) => _convertMovieToTmdbMedia(m)).toList();
      } else if (data is TopRatedTvResponse) {
        newItems = data.results.map((tv) => _convertTvToShowToTmdbMedia(tv)).toList();
      }

      if (mounted) {
        setState(() {
          _results.addAll(newItems);
          _currentPage++;
          _isLoading = false;
          if (newItems.isEmpty) {
            _hasMore = false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error loading more content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [const ThemeSwitcherWidget()],
      ),
      body: _results.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty && !_isLoading
              ? const Center(child: Text('No content found'))
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      ContentGridWidget(
                        items: _results,
                        mediaType: widget.mediaType,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
    );
  }

  TmdbMedia _convertMovieToTmdbMedia(Movie movie) {
    return TmdbMedia(
      id: movie.id,
      adult: movie.adult,
      mediaType: MediaType.movie,
      genreIds: movie.genreIds,
      popularity: movie.popularity,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      title: movie.title,
      originalTitle: movie.originalTitle,
      releaseDate: movie.releaseDate,
      video: movie.video,
    );
  }

  TmdbMedia _convertTvToShowToTmdbMedia(TvShow tv) {
    return TmdbMedia(
      id: tv.id,
      adult: false, // TvShow model doesn't have adult field
      mediaType: MediaType.tv,
      genreIds: tv.genreIds,
      popularity: tv.popularity,
      voteAverage: tv.voteAverage,
      voteCount: tv.voteCount,
      overview: tv.overview,
      posterPath: tv.posterPath,
      backdropPath: tv.backdropPath,
      name: tv.name,
      originalName: tv.originalName,
      firstAirDate: tv.firstAirDate,
      originCountry: tv.originCountry,
    );
  }
}
