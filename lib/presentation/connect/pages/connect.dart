import 'package:flutter/material.dart';
import 'package:garaage/core/config/theme/app_text.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/theme/app_colors.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(
          'Connect OBD2',
          style: AppText.pageTitleText.copyWith(color: AppColors.headingText),
        ),
      ),
      body: const Center(
        child: Text('Welcome to the Connect OBD2 Page'),
      ),
    );
  }
}