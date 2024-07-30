import 'package:dartz/dartz.dart';

import '../../data/models/auth/create_user_req.dart';
import '../../data/models/auth/sign_in_user_req.dart';

abstract class AuthRepository {
  Future<Either> signIn(SignInUserReq signInUserReq);
  Future<Either> register(CreateUserReq createUserReq);
  Future<Either> signInWithGoogle();
  Future<Either> signOut();
  Future<Either> getCurrentUser();
}
