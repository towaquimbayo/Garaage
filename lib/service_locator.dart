import 'package:garaage/data/datasources/ai_message_service.dart';
import 'package:garaage/data/repositories/ai_message_repository_impl.dart';
import 'package:garaage/domain/repositories/ai_message.dart';
import 'package:garaage/domain/usecases/chat/get_ai_message.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/auth_firebase_service.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth.dart';
import 'domain/usecases/auth/register.dart';
import 'domain/usecases/auth/sign_in.dart';
import 'domain/usecases/auth/sign_in_with_google.dart';
import 'domain/usecases/auth/sign_out.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<AiMessageService>(AiMessageServiceImpl());
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase());
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignInWithGoogleUseCase>(SignInWithGoogleUseCase());
  sl.registerSingleton<SignOutUseCase>(SignOutUseCase());
  sl.registerSingleton<AiMessageRepository>(AiMessageRepositoryImpl());
  sl.registerSingleton<GetAiMessage>(GetAiMessage());
}
