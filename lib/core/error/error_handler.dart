import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garaage/core/config/theme/app_colors.dart';

import '../config/assets/app_icons.dart';
import 'failures.dart';

class ErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    String errorMessage = 'An unexpected error occurred.';

    if (error is Failure && error.message.isNotEmpty) {
      errorMessage = error.message;
    } else if (error is Exception) {
      errorMessage = error.toString();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SvgPicture.asset(
              AppIcons.broken['forbidden']!,
              colorFilter: const ColorFilter.mode(
              AppColors.surface,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                errorMessage,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.errorDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
    
    print('Error: $error');
  }
}