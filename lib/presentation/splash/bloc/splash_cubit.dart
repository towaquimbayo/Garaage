import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<bool> {
  SplashCubit() : super(true);

  Future<void> hideSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(false);
  }
}