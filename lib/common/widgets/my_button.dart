import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garaage/core/config/theme/app_colors.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String type;
  final String text;
  final double? height;
  final String? leftIcon;
  final String? rightIcon;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.type,
    required this.text,
    this.height,
    this.leftIcon,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 48),
        backgroundColor: _getBackgroundColor(),
        foregroundColor: _getForegroundColor(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leftIcon != null) SvgPicture.asset(leftIcon!),
          const Spacer(),
          Text(text),
          const Spacer(),
          if (rightIcon != null) SvgPicture.asset(rightIcon!),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case "primary":
        return AppColors.primary;
      case "secondary":
        return AppColors.surface;
      default:
        return AppColors.background;
    }
  }

  Color _getForegroundColor() {
    return type == "primary" ? AppColors.surface : AppColors.headingText;
  }
}