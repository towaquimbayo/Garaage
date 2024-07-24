import 'package:flutter/material.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';

class DiagnosticsPage extends StatelessWidget {
  const DiagnosticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        actions: true,
        title: Text(
          'Diagnostics',
          style: AppText.pageTitleText.copyWith(color: AppColors.headingText),
        ),
      ),
      body: const Center(
        child: Text('Welcome to the Diagnostics Page'),
      ),
    );
  }
}