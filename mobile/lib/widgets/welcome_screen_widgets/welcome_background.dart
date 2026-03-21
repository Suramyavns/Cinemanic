import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  final AnimationController controller;

  const WelcomeBackground({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image with Ken Burns effect
        Positioned.fill(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.scale(
                scale: 1 + (controller.value * 0.05),
                child: Image.asset(
                  'assets/images/collage.jpg',
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.5),
                  Colors.black.withValues(alpha: 0.9),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
