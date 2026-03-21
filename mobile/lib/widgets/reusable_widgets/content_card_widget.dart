import 'package:cinemanic/screens/content_screen.dart';
import 'package:flutter/material.dart';

class ContentCardWidget extends StatefulWidget {
  const ContentCardWidget({
    super.key,
    required this.imageSrc,
    required this.contentId,
    required this.mediaType,
    this.onReturn,
  });

  final String imageSrc;
  final int contentId;
  final String mediaType;
  final VoidCallback? onReturn;

  @override
  State<ContentCardWidget> createState() => _ContentCardWidgetState();
}

class _ContentCardWidgetState extends State<ContentCardWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContentScreen(
                contentId: widget.contentId,
                mediaType: widget.mediaType,
              ),
            ),
          );
          if (widget.onReturn != null) widget.onReturn!();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: widget.imageSrc.isNotEmpty
              ? Image.network(widget.imageSrc, fit: BoxFit.cover)
              : Image.asset('assets/images/banner.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
