import 'package:flutter/material.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';

class ProfilePage extends StatelessWidget {
  static String routeName = '/profile';
  
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: true,
        backgroundColor: AppColors.surface,
        title: Text(
          'Profile',
          style: AppText.pageTitleText.copyWith(color: AppColors.headingText),
        ),
      ),
      body: const Center(
        child: Text('Welcome to the Profile Page'),
      ),
    );
  }
}