import 'package:get_it/get_it.dart';

import 'data/datasources/ai_message_service.dart';
import 'data/datasources/auth_firebase_service.dart';
import 'data/repositories/ai_message_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/ai_message.dart';
import 'domain/repositories/auth.dart';
import 'domain/usecases/auth/check_user_has_cars.dart';
import 'domain/usecases/auth/register.dart';
import 'domain/usecases/auth/sign_in.dart';
import 'domain/usecases/auth/sign_in_with_google.dart';
import 'domain/usecases/auth/sign_out.dart';
import 'domain/usecases/chat/get_ai_message.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Auth services
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase());
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignInWithGoogleUseCase>(SignInWithGoogleUseCase());
  sl.registerSingleton<SignOutUseCase>(SignOutUseCase());
  sl.registerSingleton<CheckUserHasCarsUseCase>(CheckUserHasCarsUseCase());

  // Chat services
  sl.registerSingleton<AiMessageService>(AiMessageServiceImpl());
  sl.registerSingleton<AiMessageRepository>(AiMessageRepositoryImpl());
  sl.registerSingleton<GetAiMessage>(GetAiMessage());
}
