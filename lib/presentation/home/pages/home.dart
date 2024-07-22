import 'package:flutter/material.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        actions: true,
        title: Text(
          'Welcome Noufil',
          style: AppText.pageTitleText.copyWith(color: AppColors.headingText),
        ),
      ),
      body: const Center(
        child: Text('Welcome to the Home Page'),
      ),
    );
  }
}