import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:garaage/domain/entities/user.dart';
import 'package:garaage/domain/repositories/auth.dart';

import '../../../service_locator.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  void getUser() {
    final result = sl<AuthRepository>().getUser();
    emit(ProfileState(result: result));
  }
}
