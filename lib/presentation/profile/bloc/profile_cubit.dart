import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth.dart';
import '../../../service_locator.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  void getCurrentUser() async {
    final result = await sl<AuthRepository>().getCurrentUser();
    emit(ProfileState(result: result));
  }
}
