import 'package:flutter/material.dart';

import '../../../core/config/theme/app_text.dart';

class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppText.headingText,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: AppText.bodyText,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}