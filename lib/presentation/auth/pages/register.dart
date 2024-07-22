import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../common/widgets/my_button.dart';
import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/assets/app_vectors.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';
import '../../../data/models/auth/create_user_req.dart';
import '../../../domain/usecases/auth/register.dart';
import '../../../service_locator.dart';
import '../../connect/pages/connect.dart';
import 'sign_in.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
            _passwordFields(context),
            const SizedBox(height: 24),
            _acknowledgeTerms(),
            const SizedBox(height: 24),
            MyButton(
              type: 'primary',
              text: 'Register',
              onPressed: () async {
                var result = await sl<RegisterUseCase>().call(
                  params: CreateUserReq(
                    firstName: _firstName.text.toString(),
                    lastName: _lastName.text.toString(),
                    email: _email.text.toString(),
                    password: _password.text.toString(),
                  ),
                );
                result.fold(
                  (l) {
                    var snackBar = SnackBar(
                      content: Text(l),
                      behavior: SnackBarBehavior.floating,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  (r) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const ConnectPage(),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 4),
            _redirectText(context),
            const SizedBox(height: 8),
            _withGoogle(),
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

  Widget _passwordFields(BuildContext context) {
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
        TextField(
          controller: _password,
          decoration: const InputDecoration(
            hintText: 'Create a password',
          ).applyDefaults(
            Theme.of(context).inputDecorationTheme,
          ),
        ),
      ],
    );
  }

  Widget _acknowledgeTerms() {
    return Row(
      children: [
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
            value: true,
            side: const BorderSide(color: AppColors.lightGrayDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onChanged: (value) {
              
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

  Widget _redirectText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: AppText.bodyS.copyWith(color: AppColors.bodyText),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SignInPage(),
            ),
          );
          },
          child: Text(
            'Sign In',
            style: AppText.actionM.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
  
  Widget _withGoogle() {
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
          onPressed: () {},
        )
      ],
    );
  }
}