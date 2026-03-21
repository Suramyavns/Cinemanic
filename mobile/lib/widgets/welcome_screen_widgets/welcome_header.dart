import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final AnimationController controller;

  const WelcomeHeader({
    super.key,
    required this.fadeAnimation,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        children: [
          // Animated Logo
          SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, -0.2),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: controller,
                    curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
                  ),
                ),
            child: Hero(
              tag: 'app_logo',
              child: Image.asset('assets/images/logo.png', height: 100),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'CINEMANIC',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your Ultimate Cinema Companion',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
