import 'package:cinemanic/screens/video_player.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatefulWidget {
  final int contentId;
  final String imagePath;
  final String mediaType;
  final int? startAt;
  final int? lastSeasonWatched;
  final int? lastEpisodeWatched;
  final VoidCallback? onReturn;
  final bool isAnime;
  final bool isInWatchList;
  final VoidCallback onAddToWatchList;
  final VoidCallback onRemoveFromWatchList;

  const BannerWidget({
    super.key,
    required this.contentId,
    required this.imagePath,
    required this.mediaType,
    this.startAt,
    this.lastSeasonWatched,
    this.lastEpisodeWatched,
    this.onReturn,
    required this.isAnime,
    required this.onAddToWatchList,
    required this.onRemoveFromWatchList,
    required this.isInWatchList,
  });

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Huge Rectangular Poster
        SizedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: widget.imagePath.isNotEmpty
                ? Image.network(
                    widget.imagePath,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[900],
                      child: const Icon(Icons.broken_image, size: 50),
                    ),
                  )
                : Image.asset(
                    'assets/images/banner.png',
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[900],
                      child: const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
          ),
        ),
        // Overlaid Buttons
        widget.isAnime
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  toPlay: widget.mediaType == 'tv'
                                      ? '${widget.mediaType}/${widget.contentId}/${widget.lastSeasonWatched ?? 1}/${widget.lastEpisodeWatched ?? 1}'
                                      : '${widget.mediaType}/${widget.contentId}',
                                  mediaType: widget.mediaType,
                                  isAnime: widget.isAnime,
                                  startAt: widget.startAt,
                                ),
                              ),
                            );
                            if (widget.onReturn != null) widget.onReturn!();
                          },
                          icon: const Icon(Icons.play_arrow_rounded, size: 30),
                          label: Text(
                            widget.mediaType == 'tv'
                                ? (widget.lastSeasonWatched != null
                                      ? 'Continue S${widget.lastSeasonWatched} E${widget.lastEpisodeWatched}'
                                      : 'Play S01E01')
                                : (widget.startAt != null
                                      ? 'Continue'
                                      : 'Play'),
                            style: TextStyle(
                              fontSize:
                                  widget.mediaType == 'tv' &&
                                      widget.lastSeasonWatched != null
                                  ? 14
                                  : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: () {
                            widget.isInWatchList
                                ? widget.onRemoveFromWatchList()
                                : widget.onAddToWatchList();
                          },
                          icon: widget.isInWatchList
                              ? const Icon(Icons.remove_rounded, size: 30)
                              : const Icon(Icons.add_rounded, size: 30),
                          label: Text(
                            widget.isInWatchList ? 'Remove' : 'Watchlist',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.grey[800]?.withValues(
                              alpha: 0.7,
                            ),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
