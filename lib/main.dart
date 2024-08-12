import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/config/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/auth/bloc/auth_cubit.dart';
import 'presentation/chatbot/bloc/chatbot_cubit.dart';
import 'presentation/connect/bloc/vehicle_cubit.dart';
import 'presentation/navigation/bloc/navigation_cubit.dart';
import 'presentation/onboarding/pages/onboarding.dart';
import 'presentation/profile/bloc/profile_cubit.dart';
import 'presentation/splash/bloc/splash_cubit.dart';
import 'routes.dart';
import 'service_locator.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  await dotenv.load(fileName: ".env");

  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashCubit>(
          create: (BuildContext context) => SplashCubit()..hideSplash(),
        ),
        BlocProvider<NavigationCubit>(
          create: (BuildContext context) => NavigationCubit(),
        ),
        BlocProvider<ChatbotCubit>(
          create: (BuildContext context) => ChatbotCubit(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(),
        ),
        BlocProvider<VehicleCubit>(
          create: (BuildContext context) => VehicleCubit(),
        ),
      ],
      child: BlocListener<SplashCubit, bool>(
        listener: (BuildContext context, showSplash) {
          if (!showSplash) {
            FlutterNativeSplash.remove();
          }
        },
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: OnboardingPage.routeName,
          routes: routes,
        ),
      ),
    );
  }
}
