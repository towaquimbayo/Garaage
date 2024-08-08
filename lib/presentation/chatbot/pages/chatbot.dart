import 'package:flutter/material.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';
import '../widgets/chatbot_body.dart';
import '../widgets/new_chat.dart';

class ChatbotPage extends StatelessWidget {
  static String routeName = '/chatbot';

  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(
        leading: true,
        newChat: const NewChat(),
        title: Text(
          'Mika AI',
          style: AppText.pageTitleText.copyWith(color: AppColors.headingText),
        ),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: ChatbotBody(),
        ),
      ),
    );
  }
}
