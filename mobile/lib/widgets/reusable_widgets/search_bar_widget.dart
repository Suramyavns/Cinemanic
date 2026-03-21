import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  const SearchBarWidget({super.key, this.onChanged});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Accessing theme properties
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        // Use surface colors that adjust based on theme
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: .5)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: .8),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: widget.onChanged,
        // Text color automatically follows Theme.textTheme
        style: theme.textTheme.bodyLarge,
        cursorColor: theme.colorScheme.primary,
        decoration: InputDecoration(
          hintText: 'Find your next watch...',
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.hintColor,
          ),
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: theme.colorScheme.primary,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(CupertinoIcons.clear_circled_solid),
                  onPressed: () {
                    controller.clear();
                    if (widget.onChanged != null) {
                      widget.onChanged!('');
                    }
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
