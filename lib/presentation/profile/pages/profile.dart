import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';
import '../../../core/error/error_handler.dart';
import '../../../domain/entities/user.dart';
import '../bloc/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  static String routeName = '/profile';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        UserEntity? user;
        state.result?.fold(
          (l) {
            user = l;
          },
          (r) {
            Future(() {
              ErrorHandler.handleError(context, r);
            });
          },
        );
        
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: MyAppBar(
            leading: true,
            logout: true,
            backgroundColor: AppColors.surface,
            title: Text(
              'Profile',
              style:
                  AppText.pageTitleText.copyWith(color: AppColors.headingText),
            ),
          ),
          body: _buildUI(context, user),
        );
      },
    );
  }

  Widget _buildUI(BuildContext context, UserEntity? user) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return SizedBox(
      height: screenHeight - keyboardHeight,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(
          parent: NeverScrollableScrollPhysics(),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 25,
                      offset: const Offset(0, 3),
                    )
                  ],
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(80))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 23),
                    child: SvgPicture.asset(
                      AppIcons.broken['user']!,
                      height: 40,
                    ),
                  ),
                  Text(
                    user == null
                        ? "null"
                        : "${user.firstName} ${user.lastName}",
                    style: AppText.headH3,
                  ),
                  Text(
                    user == null ? "null" : "${user.email}",
                    style: AppText.bodyS.copyWith(color: AppColors.bodyText),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "VIN",
                    style: AppText.headH5,
                  ),
                  TextField(
                    controller: TextEditingController()
                      ..text = '1NXBR32E85Z505904',
                    style: AppText.bodyText
                        .copyWith(color: AppColors.lightGrayDarkest),
                    enabled: false,
                    readOnly: true,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        filled: true,
                        fillColor: AppColors.lightGrayMedium,
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.lightGrayDarkest,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    color: AppColors.lightGrayDarkest,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Feedback",
                    style: AppText.headH5,
                  ),
                  TextField(
                    minLines: 3,
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: "What can we do better?",
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        fillColor: AppColors.lightGrayMedium,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.lightGrayDarkest,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDarkest,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Submit",
                        style:
                            AppText.actionM.copyWith(color: AppColors.surface),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
