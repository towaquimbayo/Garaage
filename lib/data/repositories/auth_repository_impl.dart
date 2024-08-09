import 'package:dartz/dartz.dart';

import '../../domain/repositories/auth.dart';
import '../../service_locator.dart';
import '../datasources/auth_firebase_service.dart';
import '../models/auth/create_user_req.dart';
import '../models/auth/sign_in_user_req.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either> register(CreateUserReq createUserReq) async {
    return await sl<AuthFirebaseService>().register(createUserReq);
  }

  @override
  Future<Either> signIn(SignInUserReq signInUserReq) async {
    return await sl<AuthFirebaseService>().signIn(signInUserReq);
  }

  @override
  Future<Either> signInWithGoogle() async {
    return await sl<AuthFirebaseService>().signInWithGoogle();
  }

  @override
  Future<Either> signOut() async {
    return await sl<AuthFirebaseService>().signOut();
  }

  @override
  Future<Either> getCurrentUser() async {
    return sl<AuthFirebaseService>().getCurrentUser();
  }

  @override
  Future<Either> checkUserHasCars() async {
    return sl<AuthFirebaseService>().checkUserHasCars();
  }
}
