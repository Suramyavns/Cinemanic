import 'package:cinemanic/utils/constants.dart';
import 'package:flutter/material.dart';

class ContentDetailsWidget extends StatelessWidget {
  const ContentDetailsWidget({
    super.key,
    required this.title,
    required this.description,
    required this.genres,
  });

  final String title;
  final String description;
  final List<String> genres;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: KTextStyle.headingTextStyle.copyWith(
              fontSize: 32,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.left,
          ),
          Text(
            description,
            style: KTextStyle.bodyTextStyle.copyWith(fontSize: 16, height: 1.5),
            textAlign: TextAlign.left,
            softWrap: true,
          ),
          Text(
            'Genres: ${genres.join(', ')}',
            style: KTextStyle.bodyTextStyle.copyWith(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey,
            ),
            textAlign: TextAlign.left,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
