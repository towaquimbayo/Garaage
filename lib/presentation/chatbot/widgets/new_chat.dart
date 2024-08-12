import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_colors.dart';
import '../bloc/chatbot_cubit.dart';

/// A stateless widget that represents a button for starting a new chat.
class NewChat extends StatelessWidget {
  const NewChat({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // When the button is pressed, it triggers the startNewChat method in ChatbotCubit.
      onPressed: () => context.read<ChatbotCubit>().startNewChat(),
      icon: Container(
        decoration: const BoxDecoration(
          // Sets the background color and shape for the button.
          color: AppColors.primaryDarkest,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          AppIcons.broken['add']!,
          width: 18,
          colorFilter: const ColorFilter.mode(
            AppColors.surface,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
