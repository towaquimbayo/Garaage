import 'package:flutter/material.dart';
import 'package:garaage/core/config/theme/app_colors.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String type;
  final String text;
  final double ? height;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.type,
    required this.text,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 48),
        backgroundColor: type == "primary" ? AppColors.primary : type == "secondary" ? AppColors.surface : AppColors.background,
        foregroundColor: type == "primary" ? AppColors.surface : AppColors.headingText,
      ),
      child: Text(text),
    );
  }
}