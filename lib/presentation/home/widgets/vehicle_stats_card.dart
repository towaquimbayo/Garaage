import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';

class VehicleStatsCard extends StatelessWidget {
  final int value;
  final String icon;
  final String mainLabel;
  final String? subLabel;
  final String? postfix;
  final bool? fixAlignment;
  final int? valueAlt;
  final String? subLabelAlt;

  const VehicleStatsCard({
    super.key,
    required this.value,
    required this.icon,
    required this.mainLabel,
    this.subLabel,
    this.postfix,
    this.fixAlignment = false,
    this.valueAlt,
    this.subLabelAlt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: valueAlt != null && subLabelAlt != null
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value.toString(),
                        style: AppText.headH1.copyWith(
                          color: AppColors.headingText,
                          fontSize: 40,
                        ),
                      ),
                      postfix != null
                          ? Text(
                              postfix!,
                              style: AppText.bodyText.copyWith(
                                color: AppColors.bodyText,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  subLabel != null
                      ? Text(
                          subLabel!,
                          style: AppText.bodyText.copyWith(
                            color: AppColors.darkGrayLightest,
                            fontSize: 14,
                          ),
                        )
                      : fixAlignment == true
                          ? const SizedBox(height: 20)
                          : const SizedBox(),
                ],
              ),
              valueAlt != null && subLabelAlt != null
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              valueAlt.toString(),
                              style: AppText.headH1.copyWith(
                                color: AppColors.headingText,
                                fontSize: 40,
                              ),
                            ),
                            postfix != null
                                ? Text(
                                    postfix!,
                                    style: AppText.bodyText.copyWith(
                                      color: AppColors.bodyText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        subLabelAlt != null
                            ? Text(
                                subLabelAlt!,
                                style: AppText.bodyText.copyWith(
                                  color: AppColors.darkGrayLightest,
                                  fontSize: 14,
                                ),
                              )
                            : fixAlignment == true
                                ? const SizedBox(height: 20)
                                : const SizedBox(),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightGrayLight,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.darkGrayLightest,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  mainLabel,
                  style: AppText.bodyText.copyWith(
                    color: AppColors.darkGrayLightest,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}