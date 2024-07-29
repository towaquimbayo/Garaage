import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';

class ConnectPage extends StatelessWidget {
  static String routeName = '/connect';
  
  const ConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: true,
        title: Text(
          'Connect OBD2',
          style: AppText.pageTitleText.copyWith(color: AppColors.headingText),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _headingText(),
            const SizedBox(height: 24),
            _availableDevices(),
          ],
        ),
      ),
    );
  }

  Widget _headingText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Searching for devices ...',
          style: AppText.headH2,
        ),
        Text(
          'Make sure your OBD2 scanner is ready and your Bluetooth is enabled',
          style: AppText.bodyS.copyWith(color: AppColors.bodyText),
        ),
      ],
    );
  }

  Widget _availableDevices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available devices',
          style: AppText.headH5,
        ),
        const SizedBox(height: 8.0),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(8.0, 0, 16.0, 0),
                tileColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SvgPicture.asset(
                    AppIcons.broken['airdrop']!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.placeholderText,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                title: Text(
                  'Device $index',
                  style: AppText.bodyM.copyWith(color: AppColors.bodyText),
                ),
                trailing: SvgPicture.asset(
                  AppIcons.broken['arrow-right']!,
                  colorFilter: const ColorFilter.mode(
                    AppColors.placeholderText,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}