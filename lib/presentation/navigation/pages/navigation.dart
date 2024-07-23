import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/my_bottom_nav_bar.dart';
import '../../ar_identify/pages/ar_identify.dart';
import '../../chatbot/pages/chatbot.dart';
import '../../diagnostics/pages/diagnostics.dart';
import '../../home/pages/home.dart';
import '../bloc/navigation_cubit.dart';

class NavigationPage extends StatelessWidget {
  static String routeName = '/navigation';
  
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavBarItem>(
      builder: (BuildContext context, state) {
        return Scaffold(
          body: _buildBody(state),
          bottomNavigationBar: const MyBottomNavBar(),
        );
      },
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
      case NavBarItem.arIdentify:
        return const ARIdentifyPage();
    }
  }
}