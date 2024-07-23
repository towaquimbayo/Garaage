import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/config/assets/app_icons.dart';
import '../../core/config/theme/app_colors.dart';
import '../../presentation/navigation/bloc/navigation_cubit.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavBarItem>(
      builder: (BuildContext context, state) {
        return BottomNavigationBar(
          currentIndex: state.index,
          onTap: (index) => _onItemTapped(context, index),
          showSelectedLabels: false,
          items: [
            _buildNavBarItem(AppIcons.broken['home']!, AppIcons.bold['home']!, 'Home', state.index == 0),
            _buildNavBarItem(AppIcons.broken['health']!, AppIcons.bold['health']!, 'Diagnostics', state.index == 1),
            _buildNavBarItem(AppIcons.broken['messages']!, AppIcons.bold['messages']!, 'Chatbot', state.index == 2),
            _buildNavBarItem(AppIcons.broken['image']!, AppIcons.bold['image']!, 'AR Identify', state.index == 3),
          ],
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavBarItem(String brokenIcon, String boldIcon, String label, bool isActive) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        isActive ? boldIcon : brokenIcon,
        colorFilter: ColorFilter.mode(
          isActive ? AppColors.primary : AppColors.lightGrayDark,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavBarItem.home);
        break;
      case 1:
        BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavBarItem.diagnostics);
        break;
      case 2:
        BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavBarItem.chatbot);
        break;
      case 3:
        BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavBarItem.arIdentify);
        break;
    }
  }
}