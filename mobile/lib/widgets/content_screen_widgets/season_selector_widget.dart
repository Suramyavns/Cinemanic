import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/screens/video_player.dart';
import 'package:cinemanic/services/content_api/tv.dart';
import 'package:flutter/material.dart';

class SeasonSelectorWidget extends StatefulWidget {
  final int tvId;
  final List<Season> seasons;
  final bool isAnime;
  final int? initialSeasonNumber;
  final VoidCallback? onReturn;

  const SeasonSelectorWidget({
    super.key,
    required this.tvId,
    required this.seasons,
    this.isAnime = false,
    this.initialSeasonNumber,
    this.onReturn,
  });


  @override
  State<SeasonSelectorWidget> createState() => _SeasonSelectorWidgetState();
}

class _SeasonSelectorWidgetState extends State<SeasonSelectorWidget> {
  Season? _selectedSeason;
  SeasonDetail? _seasonDetail;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeSelectedSeason();
  }

  void _initializeSelectedSeason() {
    if (widget.seasons.isNotEmpty) {
      if (widget.initialSeasonNumber != null) {
        final initial = widget.seasons.where(
          (s) => s.seasonNumber == widget.initialSeasonNumber,
        );
        if (initial.isNotEmpty) {
          _selectedSeason = initial.first;
          _fetchEpisodes();
          return;
        }
      }

      // Exclude specials (season 0) if possible, or just pick first
      final availableSeasons = widget.seasons
          .where((s) => s.seasonNumber > 0)
          .toList();
      if (availableSeasons.isNotEmpty) {
        _selectedSeason = availableSeasons.first;
      } else {
        _selectedSeason = widget.seasons.first;
      }
      _fetchEpisodes();
    }
  }

  @override
  void didUpdateWidget(covariant SeasonSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If seasons changed (or isAnime toggled), ensure the selected season is still valid
    if (widget.seasons != oldWidget.seasons ||
        widget.isAnime != oldWidget.isAnime) {
      final displayedSeasons = widget.isAnime
          ? widget.seasons.where((s) => s.seasonNumber == 1).toList()
          : widget.seasons.where((s) => s.seasonNumber > 0).toList();

      if (displayedSeasons.isEmpty) {
        _selectedSeason = null;
        _seasonDetail = null;
      } else if (_selectedSeason == null ||
          !displayedSeasons.contains(_selectedSeason)) {
        _selectedSeason = displayedSeasons.first;
        _fetchEpisodes();
      }
    }
  }

  Future<void> _fetchEpisodes() async {
    if (_selectedSeason == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final detail = await fetchSeasonDetails(
        widget.tvId,
        _selectedSeason!.seasonNumber,
      );
      if (mounted) {
        setState(() {
          _seasonDetail = detail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error fetching episodes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter seasons for anime rule
    final displayedSeasons = widget.isAnime
        ? widget.seasons.where((s) => s.seasonNumber == 1).toList()
        : widget.seasons.where((s) => s.seasonNumber > 0).toList();

    if (displayedSeasons.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
          child: Row(
            children: [
              Text(
                'Season:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<Season>(
                value: _selectedSeason,
                items: displayedSeasons.map((s) {
                  return DropdownMenuItem(value: s, child: Text(s.name));
                }).toList(),
                onChanged: (season) {
                  if (season != null && season != _selectedSeason) {
                    setState(() {
                      _selectedSeason = season;
                    });
                    _fetchEpisodes();
                  }
                },
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_seasonDetail != null)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: _seasonDetail!.episodes.length,
            itemBuilder: (context, index) {
              final episode = _seasonDetail!.episodes[index];
              return ListTile(
                leading: episode.stillPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          episode.stillUrl!,
                          width: 80,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 45,
                        color: Colors.grey,
                        child: const Icon(Icons.tv),
                      ),
                title: Text('${episode.episodeNumber}. ${episode.name}'),
                subtitle: Text(
                  episode.airDate,
                  style: theme.textTheme.bodySmall,
                ),
                trailing: SizedBox(
                  width: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(
                        episode.voteAverage.toStringAsFixed(1),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                        toPlay:
                            'tv/${widget.tvId}/${episode.seasonNumber}/${episode.episodeNumber}',
                        mediaType: 'tv',
                      ),
                    ),
                  );
                  if (widget.onReturn != null) widget.onReturn!();
                },
              );
            },
          ),
      ],
    );
  }
}
