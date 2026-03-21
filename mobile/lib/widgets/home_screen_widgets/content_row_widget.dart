import 'package:cinemanic/utils/constants.dart';
import 'package:cinemanic/utils/images.dart';
import 'package:cinemanic/widgets/reusable_widgets/content_card_widget.dart';
import 'package:flutter/material.dart';

// The "Parent" or Base Class
class ContentRowWidget extends StatefulWidget {
  const ContentRowWidget({
    super.key,
    required this.title,
    required this.data,
    required this.mediaType,
    this.onReturn,
    this.onViewMore,
  });

  final String title;
  final dynamic data;
  final String mediaType;
  final VoidCallback? onReturn;
  final VoidCallback? onViewMore;

  @override
  State<ContentRowWidget> createState() => _ContentRowWidgetState();
}

class _ContentRowWidgetState extends State<ContentRowWidget> {
  // 1. Define abstract methods that children MUST implement
  late List<dynamic> results;

  @override
  void initState() {
    setState(() {
      if (widget.data is List) {
        results = widget.data;
      } else {
        results = widget.data.results;
        try {
          results.sort((a, b) => (b.voteAverage - a.voteAverage).toInt());
        } catch (_) {}
      }
    });
    super.initState();
  }

  String getMediaType(int index) {
    if (widget.mediaType == 'history' || widget.mediaType == 'watchlist') {
      return results[index].type;
    } else if (widget.mediaType == 'trending' ||
        widget.mediaType == 'recommendations') {
      return results[index].toJson()['media_type'];
    } else {
      return widget.mediaType;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3. This is the "Master Template"
    if (results.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.left,
                style: KTextStyle.headingTextStyle,
              ),
              if (widget.onViewMore != null)
                GestureDetector(
                  onTap: widget.onViewMore,
                  child: const Row(
                    children: [
                      Text(
                        'view more',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.double_arrow, color: Colors.grey, size: 14),
                    ],
                  ),
                ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 16,
              children: [
                ...List.generate(results.length > 10 ? 10 : results.length, (
                  index,
                ) {
                  return ContentCardWidget(
                    imageSrc: imageUrlBuilder(results[index].posterPath ?? ''),
                    contentId: widget.mediaType == 'watchlist'
                        ? results[index].mediaId
                        : results[index].id,
                    mediaType: getMediaType(index),
                    onReturn: widget.onReturn,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
