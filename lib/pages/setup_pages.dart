import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final Color color;
  final String image;
  final String title;
  final String subtitle;

  const OnboardingPage({
    required this.color,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    const double verticalSpacing = 20;
    const double horizontalSpacing = 20;

    // OnboardingPage
    return Container(
      padding: const EdgeInsets.only(
        left: horizontalSpacing,
        right: horizontalSpacing,
      ),
      color: color, // BackgroundColor
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Image.asset(image),
          const SizedBox(height: verticalSpacing),
          // Title
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: verticalSpacing),
          // Subtitle
          Center(
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
