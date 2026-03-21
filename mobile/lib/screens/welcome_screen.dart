import 'package:flutter/material.dart';
import 'package:cinemanic/widgets/welcome_screen_widgets/welcome_background.dart';
import 'package:cinemanic/widgets/welcome_screen_widgets/welcome_header.dart';
import 'package:cinemanic/widgets/welcome_screen_widgets/google_sign_in_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double deviceHeight = constraints.maxHeight;
          return Stack(
            children: [
              WelcomeBackground(controller: _controller),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WelcomeHeader(
                          fadeAnimation: _fadeAnimation,
                          controller: _controller,
                        ),
                        SizedBox(height: deviceHeight * .025),
                        GoogleSignInButton(
                          fadeAnimation: _fadeAnimation,
                          slideAnimation: _slideAnimation,
                        ),
                        SizedBox(height: deviceHeight * 0.025),
                        // Footer Text
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'By continuing, you agree to our Terms & Privacy Policy',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
