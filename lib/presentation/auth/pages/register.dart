import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../common/widgets/my_button.dart';
import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/assets/app_vectors.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/error/failures.dart';
import '../../../data/models/auth/create_user_req.dart';
import '../../../domain/usecases/auth/check_user_has_cars.dart';
import '../../../domain/usecases/auth/register.dart';
import '../../../domain/usecases/auth/sign_in_with_google.dart';
import '../../../service_locator.dart';
import '../../connect/pages/connect.dart';
import '../../navigation/pages/navigation.dart';
import 'sign_in.dart';

class RegisterPage extends StatelessWidget {
  static String routeName =  '/register';
  
  RegisterPage({super.key});

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _termsAccepted = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: true,
        title: SvgPicture.asset(
          AppVectors.logo,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
          height: 24,
        )
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _registerText(),
            const SizedBox(height: 24),
            _nameFields(context),
            const SizedBox(height: 16),
            _emailField(context),
            const SizedBox(height: 16),
            _passwordField(context),
            const SizedBox(height: 24),
            _acknowledgeTerms(),
            const SizedBox(height: 24),
            MyButton(
              type: 'primary',
              text: 'Register',
              onPressed: () async {
                if (!_termsAccepted.value) {
                  String type = 'error';
                  String message = 'Please accept the terms and conditions.';
                  ErrorHandler.handleError(context, ClientFailure(type, message));
                  return;
                }
                
                var result = await sl<RegisterUseCase>().call(
                  params: CreateUserReq(
                    firstName: _firstName.text.toString(),
                    lastName: _lastName.text.toString(),
                    email: _email.text.toString(),
                    password: _password.text.toString(),
                  ),
                );
                result.fold(
                  (l) => ErrorHandler.handleError(context, l),
                  (r) async {
                    var hasCarResult = await sl<CheckUserHasCarsUseCase>().call();
                    hasCarResult.fold(
                      (hasCars) {
                        if (hasCars) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            NavigationPage.routeName,
                            (route) => false,
                          );
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            ConnectPage.routeName,
                            (route) => false,
                          );
                        }
                      },
                      (error) => ErrorHandler.handleError(context, error),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 4),
            _redirectText(context),
            const SizedBox(height: 8),
            _withGoogle(context),
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Register',
          style: AppText.headH2,
        ),
        Text(
          'Create an account to get started',
          style: AppText.bodyS.copyWith(color: AppColors.bodyText),
        ),
      ],
    );
  }

  Widget _nameFields(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'First Name',
                  style: AppText.headH5.copyWith(color: AppColors.headingText),
                ),
              ),
              TextField(
                controller: _firstName,
                decoration: const InputDecoration(
                  hintText: 'John',
                ).applyDefaults(
                  Theme.of(context).inputDecorationTheme,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Last Name',
                  style: AppText.headH5.copyWith(color: AppColors.headingText),
                ),
              ),
              TextField(
                controller: _lastName,
                decoration: const InputDecoration(
                  hintText: 'Doe',
                ).applyDefaults(
                  Theme.of(context).inputDecorationTheme,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emailField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Email',
            style: AppText.headH5.copyWith(color: AppColors.headingText),
          ),
        ),
        TextField(
          controller: _email,
          decoration: const InputDecoration(
            hintText: 'name@email.com',
          ).applyDefaults(
            Theme.of(context).inputDecorationTheme,
          ),
        ),
      ],
    );
  }

  Widget _passwordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Password',
            style: AppText.headH5.copyWith(color: AppColors.headingText),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _passwordVisible,
          builder: (context, isVisible, child) {
            return TextField(
              controller: _password,
              obscureText: !isVisible,
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(
                  icon: SvgPicture.asset(
                    AppIcons.broken[isVisible ? 'eye' : 'eye-slash']!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.placeholderText,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {
                    _passwordVisible.value = !isVisible;
                  }, 
                )
              ).applyDefaults(
                Theme.of(context).inputDecorationTheme,
              ),
            );
          }
        ),
      ],
    );
  }

  Widget _acknowledgeTerms() {
    return ValueListenableBuilder<bool>(
      valueListenable: _termsAccepted,
      builder: (context, isAccepted, child) {
        return Row(
          children: [
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: isAccepted,
                side: const BorderSide(color: AppColors.lightGrayDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onChanged: (value) {
                  _termsAccepted.value = value ?? false;
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'I\'ve read and agree with the ',
                      style: AppText.bodyS.copyWith(color: AppColors.darkGrayLight),
                    ),
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: AppText.actionM.copyWith(color: AppColors.primary),
                    ),
                    TextSpan(
                      text: ' and the ',
                      style: AppText.bodyS.copyWith(color: AppColors.darkGrayLight),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: AppText.actionM.copyWith(color: AppColors.primary),
                    ),
                    TextSpan(
                      text: '.',
                      style: AppText.bodyS.copyWith(color: AppColors.darkGrayLight),
                    ),
                  ],
                ),
                softWrap: true,
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _redirectText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: AppText.bodyS.copyWith(color: AppColors.bodyText),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed(SignInPage.routeName),
          child: Text(
            'Sign In',
            style: AppText.actionM.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
  
  Widget _withGoogle(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          color: AppColors.lightGrayMedium,
        ),
        const SizedBox(height: 24),
        MyButton(
          type: 'secondary',
          text: 'Continue with Google',
          leftIcon: AppIcons.broken['google'],
          onPressed: () async {
            var result = await sl<SignInWithGoogleUseCase>().call();
            result.fold(
              (l) => ErrorHandler.handleError(context, l),
              (r) async {
                var hasCarResult = await sl<CheckUserHasCarsUseCase>().call();
                hasCarResult.fold(
                  (hasCars) {
                    if (hasCars) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        NavigationPage.routeName,
                        (route) => false,
                      );
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        ConnectPage.routeName,
                        (route) => false,
                      );
                    }
                  },
                  (error) => ErrorHandler.handleError(context, error),
                );
              },
            );
          },
        )
      ],
    );
  }
}