import 'package:flutter/material.dart';

import 'presentation/auth/pages/register.dart';
import 'presentation/auth/pages/sign_in.dart';
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
};