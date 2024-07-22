import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/my_button.dart';
import '../../../core/config/assets/app_vectors.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../auth/pages/register.dart';
import '../../auth/pages/sign_in.dart';
import '../widgets/onboarding_content.dart';


class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currSlide = 0;
  final PageController _pageController = PageController();

  List<Map<String, String>> onboardingData = [
    {
      'title': 'Meet Your Car Mechanic',
      'description':
          'Instantly diagnose car problems with a simple scan using OBD2, giving you clear, easy-to-understand reports.',
    },
    {
      'title': 'From Diagnosis to DIY Fix',
      'description':
          'Garaage doesn\'t just find problems, it guides you to solutions. Get step-by-step repair instructions and even parts recommendations.',
    },
    {
      'title': 'Introducing Mika AI',
      'description':
          'Confused about a diagnostic report? Our AI chatbot is ready to answer your questions, making car care less complicated.',
    },
    {
      'title': 'Identify & Learn with AR',
      'description':
          'Use Augmented Reality to identify your car\'s model and discover the names of different parts just by pointing your camera.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: SvgPicture.asset(AppVectors.topPattern),
              ),
              const SizedBox(height: 20),
              SvgPicture.asset(
                AppVectors.logo,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.bottomLeft,
                child: SvgPicture.asset(AppVectors.bottomPattern),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currSlide = index;
                        });
                      },
                      itemCount: onboardingData.length,
                      itemBuilder: (context, index) => OnboardingContent(
                        title: onboardingData[index]['title']!,
                        description: onboardingData[index]['description']!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => buildDot(index: index),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: MyButton(
                          type: "primary",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => RegisterPage(),
                              ),
                            );
                          }, 
                          text: "Register",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: MyButton(
                          type: "other",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SignInPage(),
                              ),
                            );
                          },
                          text: "Sign In",
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 6),
      height: 10,
      width: currSlide == index ? 30 : 10,
      decoration: BoxDecoration(
        color: currSlide == index ? AppColors.primary : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}