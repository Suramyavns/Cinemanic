import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:cinemanic/utils/images.dart';
import 'package:cinemanic/widgets/reusable_widgets/content_card_widget.dart';
import 'package:flutter/material.dart';

class CreditGridWidget extends StatelessWidget {
  const CreditGridWidget({super.key, required this.credits});

  final List<BaseCredit> credits;

  @override
  Widget build(BuildContext context) {
    // Filter out credits without poster path to keep the UI clean
    final filteredCredits = credits.where((c) => c.posterPath != null).toList();

    if (filteredCredits.isEmpty) {
      return Center(
        child: Text('No credits found', style: KTextStyle.bodyTextStyle),
      );
    }

    filteredCredits.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));

    return GridView.builder(
      padding: const EdgeInsets.only(top: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredCredits.length,
      itemBuilder: (context, index) {
        final credit = filteredCredits[index];
        return ContentCardWidget(
          imageSrc: imageUrlBuilder(credit.posterPath!),
          contentId: credit.id,
          mediaType: credit.mediaType,
        );
      },
    );
  }
}
