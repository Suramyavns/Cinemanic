import 'package:cinemanic/screens/home_screen.dart';
import 'package:cinemanic/screens/profile_screen.dart';
import 'package:cinemanic/screens/welcome_screen.dart';
import 'package:cinemanic/utils/notifiers.dart';
import 'package:cinemanic/widgets/reusable_widgets/custom_appbar_widget.dart';
import 'package:cinemanic/widgets/reusable_widgets/navigation_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> screens = [HomeScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return Scaffold(
            appBar: CustomAppBarWidget(),
            body: ValueListenableBuilder(
              valueListenable: selectedIndexNotifier,
              builder: (context, selectedtIndex, child) {
                return screens.elementAt(selectedtIndex);
              },
            ),
            bottomNavigationBar: NavigationBarWidget(),
          );
        }

        return const WelcomeScreen();
      },
    );
  }
}
