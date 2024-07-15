import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:garaage/conts.dart';
import 'package:garaage/presentation/chatbot/pages/chatbot.dart';

import 'core/config/theme/app_theme.dart';

void main() {
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const Chatbot());
  }
}
