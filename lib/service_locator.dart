import 'package:get_it/get_it.dart';

import 'data/datasources/auth_firebase_service.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth.dart';
import 'domain/usecases/auth/register.dart';
import 'domain/usecases/auth/sign_in.dart';
import 'domain/usecases/auth/sign_in_with_google.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase());
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignInWithGoogleUseCase>(SignInWithGoogleUseCase());
}