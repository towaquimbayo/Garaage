import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';

class FuelConsumptionCard extends StatelessWidget {
  final int currentConsumed;
  final int totalConsumed;

  const FuelConsumptionCard({
    super.key,
    required this.currentConsumed,
    required this.totalConsumed,
  });

  // progress bar
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      LinearProgressIndicator(
        value: currentConsumed / totalConsumed,
        backgroundColor: AppColors.lightGrayMedium,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        semanticsLabel: 'Fuel Consumption',
        semanticsValue: '$currentConsumed / $totalConsumed',
        minHeight: 30,
        borderRadius: BorderRadius.circular(50),
      ),
      Positioned(
        left: 20,
        top: 0,
        bottom: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.broken['fuel']!,
              width: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.surface,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Fuel',
              style: AppText.bodyText.copyWith(color: AppColors.surface),
            ),
          ],
        ),
      ),
    ]);
  }
}