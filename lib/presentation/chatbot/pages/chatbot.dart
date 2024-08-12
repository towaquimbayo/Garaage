import 'package:flutter/material.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';
import '../widgets/chatbot_body.dart';
import '../widgets/new_chat.dart';

/// A stateless widget representing the chatbot page.
class ChatbotPage extends StatelessWidget {
  /// The route name for navigation to this page.
  static String routeName = '/chatbot';

  /// Constructor for the ChatbotPage widget.
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Allows the page to resize when the keyboard appears.
      resizeToAvoidBottomInset: true,

      // The custom app bar for the chatbot page.
      appBar: MyAppBar(
        leading: true, // Indicates if there is a leading widget in the app bar.
        newChat: const NewChat(), // Widget for starting a new chat.
        title: Text(
          'Mika AI', // Title displayed in the app bar.
          style: AppText.pageTitleText.copyWith(
            color: AppColors.headingText, // Title text color.
          ),
        ),
      ),

      // The body of the chatbot page, wrapped in a SingleChildScrollView to allow scrolling.
      body: const SingleChildScrollView(
        child: Center(
          child: ChatbotBody(), // The main content of the chatbot page.
        ),
      ),
    );
  }
}
