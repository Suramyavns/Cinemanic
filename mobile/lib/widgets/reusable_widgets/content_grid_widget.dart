import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/widgets/reusable_widgets/content_card_widget.dart';
import 'package:flutter/material.dart';

class ContentGridWidget extends StatelessWidget {
  final List<TmdbMedia> items;
  final String mediaType;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  const ContentGridWidget({
    super.key,
    required this.items,
    required this.mediaType,
    this.physics,
    this.shrinkWrap = false,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No content found'));
    }

    return GridView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ContentCardWidget(
          imageSrc: item.posterUrl ?? '',
          contentId: item.id,
          mediaType: mediaType,
        );
      },
    );
  }
}
