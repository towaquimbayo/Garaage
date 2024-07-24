import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garaage/core/config/theme/app_colors.dart';
import 'package:garaage/presentation/chatbot/pages/chatbot.dart';

import '../../../common/widgets/my_bottom_nav_bar.dart';
import '../../../core/config/theme/app_text.dart';
import '../../diagnostics/pages/diagnostics.dart';
import '../../home/pages/home.dart';
import '../bloc/navigation_cubit.dart';

class NavigationPage extends StatelessWidget {
  static String routeName = '/navigation';

  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final result = await _showExitConfirmationDialog(context);
        if (result == true) {
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<NavigationCubit, NavBarItem>(
        builder: (BuildContext context, state) {
          return Scaffold(
            body: _buildBody(state),
            bottomNavigationBar: const MyBottomNavBar(),
          );
        },
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Exit App',
          style: AppText.headH1,
        ),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No',
                style: TextStyle(color: AppColors.placeholderText)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              exit(0);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(NavBarItem item) {
    switch (item) {
      case NavBarItem.home:
        return const HomePage();
      case NavBarItem.diagnostics:
        return const DiagnosticsPage();
      case NavBarItem.chatbot:
        return const ChatbotPage();
      default:
        return const HomePage();
    }
  }
}
