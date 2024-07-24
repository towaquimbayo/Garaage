import 'package:flutter_bloc/flutter_bloc.dart';

enum NavBarItem { home, diagnostics, chatbot, arIdentify }

class NavigationCubit extends Cubit<NavBarItem> {
  NavigationCubit() : super(NavBarItem.home);

  void getNavBarItem(NavBarItem item) => emit(item);  
}