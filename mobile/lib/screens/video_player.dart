import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adblocker_webview/adblocker_webview.dart';
import 'package:cinemanic/services/content_api/player.dart';
import 'package:cinemanic/services/content_api/tv.dart';
import 'package:cinemanic/models/tmdb_models.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String toPlay;
  final String mediaType;
  final bool isAnime;
  final int? startAt;

  const VideoPlayerScreen({
    super.key,
    required this.toPlay,
    required this.mediaType,
    this.isAnime = false,
    this.startAt,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _isLoading = true;
  String? _videoUrl;
  bool _hasError = false;
  late WebViewController controller;

  // New state for "Next Episode" logic
  int? _tvId;
  int? _currentSeason;
  int? _currentEpisode;
  TvShowDetail? _showDetail;
  String? _currentToPlay;

  @override
  void initState() {
    super.initState();
    _currentToPlay = widget.toPlay;
    _parseToPlay();
    _lockOrientation();
    _loadVideoUrl();
    _loadShowDetails();
  }

  void _parseToPlay() {
    final parts = _currentToPlay!.split('/');
    if (parts.length >= 2 && widget.mediaType == 'tv') {
      _tvId = int.tryParse(parts[1]);
      if (parts.length >= 4) {
        _currentSeason = int.tryParse(parts[2]);
        _currentEpisode = int.tryParse(parts[3]);
      }
    }
  }

  Future<void> _loadShowDetails() async {
    if (widget.mediaType == 'tv' && _tvId != null) {
      try {
        final detail = await fetchTvShowById(_tvId!);
        if (mounted) {
          setState(() {
            _showDetail = detail;
          });
        }
      } catch (e) {
        debugPrint('Error loading show details for navigation: $e');
      }
    }
  }

  void _lockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _loadVideoUrl({int? startFrom}) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final url = await fetchVideoPlayer(
        _currentToPlay!,
        token!,
        startAt: startFrom ?? widget.startAt,
        isAnime: widget.isAnime,
      );

      if (mounted) {
        setState(() {
          _videoUrl = url;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  void _handleNextEpisode() async {
    if (_showDetail == null ||
        _currentSeason == null ||
        _currentEpisode == null)
      return;

    final currentSeasonData = _showDetail!.seasons.firstWhere(
      (s) => s.seasonNumber == _currentSeason,
    );

    int nextEpisode = _currentEpisode! + 1;
    int nextSeason = _currentSeason!;

    if (nextEpisode > currentSeasonData.episodeCount) {
      // Try next season
      final nextSeasonNumber = _currentSeason! + 1;
      final nextSeasonExists =
          _showDetail!.seasons.any((s) => s.seasonNumber == nextSeasonNumber);

      if (nextSeasonExists) {
        nextSeason = nextSeasonNumber;
        nextEpisode = 1;
      } else {
        // No more episodes/seasons
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No more episodes available')),
          );
        }
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _currentEpisode = nextEpisode;
      _currentToPlay = 'tv/$_tvId/$nextSeason/$nextEpisode';
    });

    await _loadVideoUrl(startFrom: 0);
  }

  @override
  void dispose() {
    _resetOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_videoUrl != null)
            AdBlockerWebview(
              key: ValueKey(_videoUrl),
              url: Uri.parse(_videoUrl!),
              shouldBlockAds: true,
              adBlockerWebviewController: AdBlockerWebviewController.instance,
            ),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blue),
                  SizedBox(height: 16),
                  Text(
                    'Loading Player...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load video player',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          // Overlay Controls
          Positioned(
            top: 24,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                if (widget.mediaType == 'tv' && _showDetail != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton.icon(
                      onPressed: _handleNextEpisode,
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: const Text(
                        'Next Episode',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
