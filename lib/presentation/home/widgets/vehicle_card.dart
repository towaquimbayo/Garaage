import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';

class VehicleCard extends StatelessWidget {
  final String name;
  final String description;
  final Widget image;
  final int errors;
  final String transmission;
  final int numSeats;
  final String status;

  const VehicleCard({
    super.key,
    required this.name,
    required this.description,
    required this.image,
    required this.errors,
    required this.transmission,
    required this.numSeats,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppText.headH3.copyWith(
                        color: AppColors.headingText,
                      ),
                    ),
                    Text(
                      description,
                      style: AppText.bodyS.copyWith(
                        color: AppColors.bodyText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(child: image),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.broken['transmission']!,
                          width: 18,
                          colorFilter: const ColorFilter.mode(
                            AppColors.darkGrayLightest,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          transmission,
                          style: AppText.bodyS.copyWith(
                            color: AppColors.darkGrayLightest,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.broken['people']!,
                          width: 18,
                          colorFilter: const ColorFilter.mode(
                            AppColors.darkGrayLightest,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$numSeats Seats',
                          style: AppText.bodyS.copyWith(
                            color: AppColors.darkGrayLightest,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: status == 'Disconnected'
                        ? AppColors.lightGrayMedium
                        : errors > 0
                            ? Colors.red[100]
                            : Colors.green[50],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: status == 'Disconnected'
                            ? AppColors.darkGrayLightest
                            : errors > 0
                                ? Colors.red
                                : Colors.green,
                        size: 10,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        status == 'Disconnected' ? status : '$errors Errors',
                        style: AppText.bodyS.copyWith(
                          color: AppColors.bodyText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}