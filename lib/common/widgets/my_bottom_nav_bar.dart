import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/config/assets/app_icons.dart';
import '../../core/config/theme/app_colors.dart';
import '../../presentation/ar_identify/pages/ar_identify.dart';
import '../../presentation/chatbot/pages/chatbot.dart';
import '../../presentation/navigation/bloc/navigation_cubit.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavBarItem>(
      builder: (BuildContext context, state) {
        return Stack(
          children: [
            NavigationBar(
              selectedIndex: state.index,
              onDestinationSelected: (index) => _onItemTapped(context, index),
              height: 64,
              indicatorColor: Colors.transparent,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              destinations: [
                NavigationDestination(
                  icon: SvgPicture.asset(
                    AppIcons.broken['home']!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.lightGrayDark,
                      BlendMode.srcIn,
                    ),
                    height: 28,
                  ),
                  selectedIcon: SvgPicture.asset(
                    AppIcons.bold['home']!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: SvgPicture.asset(
                    AppIcons.broken['health']!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.lightGrayDark,
                      BlendMode.srcIn,
                    ),
                  ),
                  selectedIcon: SvgPicture.asset(
                    AppIcons.bold['health']!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Diagnostics',
                ),
                NavigationDestination(
                  icon: SvgPicture.asset(
                    AppIcons.broken['messages']!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.lightGrayDark,
                      BlendMode.srcIn,
                    ),
                  ),
                  selectedIcon: SvgPicture.asset(
                    AppIcons.bold['messages']!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Chatbot',
                ),
                NavigationDestination(
                  icon: SvgPicture.asset(
                    AppIcons.broken['image']!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.lightGrayDark,
                      BlendMode.srcIn,
                    ),
                  ),
                  selectedIcon: SvgPicture.asset(
                    AppIcons.bold['image']!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'AR Identify',
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: _getIndicatorPosition(state, context),
              child: Container(
                height: 4,
                width: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _getIndicatorPosition(NavBarItem state, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth =
        screenWidth / 4; // 4 is the number of items in the bottom nav bar
    switch (state) {
      case NavBarItem.home:
        return itemWidth / 2 - 16; // 16 is half the indicator width
      case NavBarItem.diagnostics:
        return itemWidth * 1.5 - 16;
      case NavBarItem.chatbot:
        return itemWidth * 2.5 - 16;
      case NavBarItem.arIdentify:
        return itemWidth * 3.5 - 16;
      default:
        return 0;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        BlocProvider.of<NavigationCubit>(context)
            .getNavBarItem(NavBarItem.home);
        break;
      case 1:
        BlocProvider.of<NavigationCubit>(context)
            .getNavBarItem(NavBarItem.diagnostics);
        break;
      case 2:
        Navigator.of(context).pushNamed(ChatbotPage.routeName);
        break;
      case 3:
        Navigator.of(context).pushNamed(ARIdentifyPage.routeName);
        break;
    }
  }
}
