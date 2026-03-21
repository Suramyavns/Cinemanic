import 'package:cinemanic/utils/notifiers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeSwitcherWidget extends StatefulWidget {
  const ThemeSwitcherWidget({super.key});

  @override
  State<ThemeSwitcherWidget> createState() => _ThemeSwitcherWidgetState();
}

class _ThemeSwitcherWidgetState extends State<ThemeSwitcherWidget> {
  void handleThemeSwitch() {
    setState(() {
      // You MUST assign the new value here
      isDarkNotifier.value = !isDarkNotifier.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: handleThemeSwitch,
      icon: isDarkNotifier.value
          ? Icon(CupertinoIcons.moon)
          : Icon(CupertinoIcons.sun_max),
    );
  }
}
