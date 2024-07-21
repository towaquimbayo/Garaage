import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../common/widgets/my_button.dart';
import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/assets/app_vectors.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';
import '../../connect/pages/connect.dart';
import 'register.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
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
            _signInText(),
            const SizedBox(height: 24),
            _emailField(context),
            const SizedBox(height: 16),
            _passwordField(context),
            const SizedBox(height: 24),
            MyButton(
              type: 'primary',
              text: 'Sign In',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const ConnectPage(),
                  ),
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

  Widget _signInText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sign In',
          style: AppText.headH2,
        ),
        Text(
          'Enter your account details',
          style: AppText.bodyS.copyWith(color: AppColors.bodyText),
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
        TextField(
          decoration: const InputDecoration(
            hintText: 'Password',
          ).applyDefaults(
            Theme.of(context).inputDecorationTheme,
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
          'Don\'t have an account?',
          style: AppText.bodyS.copyWith(color: AppColors.bodyText),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const RegisterPage(),
              ),
            );
          },
          child: Text(
            'Register Now',
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