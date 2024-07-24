import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/models/auth/sign_in_user_req.dart';
import '../../../service_locator.dart';
import '../../repositories/auth.dart';

class SignInUseCase implements UseCase<Either, SignInUserReq> {
  @override
  Future<Either> call({SignInUserReq? params}) async {
    return sl<AuthRepository>().signIn(params!);
  }
}