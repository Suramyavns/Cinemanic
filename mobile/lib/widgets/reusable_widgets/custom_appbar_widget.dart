import 'package:cinemanic/widgets/theme_switcher_widget.dart';
import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: EdgeInsets.symmetric(horizontal: 4),
      title: Text(
        'Cinemanic',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,

          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      actions: [ThemeSwitcherWidget()],
    );
  }
}
