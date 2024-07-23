import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/config/theme/app_colors.dart';
import '../../core/config/assets/app_icons.dart';
import '../../presentation/profile/pages/profile.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool? leading;
  final bool? actions;
  final Color? backgroundColor;

  const MyAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor = AppColors.background,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        elevation: 0,
        title: title ?? const Text(''),
        centerTitle: true,
        leading: leading == true
            ? IconButton(
                icon: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    AppIcons.broken['arrow-left']!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.headingText,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : const SizedBox(),
        actions: actions == true
            ? [
                IconButton(
                  icon: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      AppIcons.broken['user']!,
                      colorFilter: const ColorFilter.mode(
                        AppColors.headingText,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ProfilePage.routeName,
                    );
                  },
                ),
              ]
            : const [],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
