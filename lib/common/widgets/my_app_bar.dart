import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/config/theme/app_colors.dart';
import '../../core/config/assets/app_icons.dart';
import '../../core/error/error_handler.dart';
import '../../domain/usecases/auth/sign_out.dart';
import '../../presentation/onboarding/pages/onboarding.dart';
import '../../presentation/profile/pages/profile.dart';
import '../../service_locator.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool? leading;
  final bool? actions;
  final bool? logout;
  final Color? backgroundColor;
  final Widget? newChat;

  const MyAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.logout,
    this.newChat,
    this.backgroundColor = AppColors.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Padding(
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
                    onPressed: () =>
                        Navigator.of(context).pushNamed(ProfilePage.routeName),
                  ),
                ]
              : logout == true
                  ? [
                      IconButton(
                        icon: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.errorDark,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.fromLTRB(6, 8, 10, 8),
                          child: SvgPicture.asset(
                            AppIcons.broken['logout']!,
                            colorFilter: const ColorFilter.mode(
                              AppColors.surface,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          var result = await sl<SignOutUseCase>().call();
                          result.fold(
                            (l) => ErrorHandler.handleError(context, l),
                            (r) => Navigator.of(context)
                                .pushNamedAndRemoveUntil(
                                    OnboardingPage.routeName, (route) => false),
                          );
                        },
                      ),
                    ]
                  : newChat != null
                      ? [newChat!]
                      : [],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
