import 'package:cinemanic/utils/notifiers.dart';
import 'package:flutter/material.dart';

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({super.key});

  final List<NavigationDestination> destinations = const [
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedIndexNotifier,
      builder: (context, value, child) {
        return NavigationBar(
          onDestinationSelected: (value) {
            selectedIndexNotifier.value = value;
          },
          indicatorColor: Colors.transparent,
          height: MediaQuery.of(context).size.height * 0.08,
          destinations: destinations,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: value,
        );
      },
    );
  }
}
