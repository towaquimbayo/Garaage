import 'package:flutter/material.dart';

import 'presentation/ar_identify/pages/ar_identify.dart';
import 'presentation/auth/pages/register.dart';
import 'presentation/auth/pages/sign_in.dart';
import 'presentation/chatbot/pages/chatbot.dart';
import 'presentation/connect/pages/connect.dart';
import 'presentation/navigation/pages/navigation.dart';
import 'presentation/onboarding/pages/onboarding.dart';
import 'presentation/profile/pages/profile.dart';

final Map<String, WidgetBuilder> routes = {
  OnboardingPage.routeName: (context) => const OnboardingPage(),
  SignInPage.routeName: (context) => SignInPage(),
  RegisterPage.routeName: (context) => RegisterPage(),
  ConnectPage.routeName: (context) => const ConnectPage(),
  NavigationPage.routeName: (context) => const NavigationPage(),
  ProfilePage.routeName: (context) => const ProfilePage(),
  ARIdentifyPage.routeName: (context) => const ARIdentifyPage(),
  ChatbotPage.routeName: (context) => const ChatbotPage(),
};
