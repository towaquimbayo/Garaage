import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/assets/app_vectors.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // @TODO: Replace with DB / Bloc data
  static const username = 'USER';
  static Map<String, dynamic> vehicle = {
    'name': 'Honda Civic',
    'description': '2021 Sport Hybrid Edition',
    'image': SvgPicture.asset(
      AppVectors.hondaCivic,
      fit: BoxFit.contain,
      height: 70,
    ),
    'errors': 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(
          'Welcome $username',
          style: AppText.pageTitleText.copyWith(color: AppColors.headingText),
        ),
        actions: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: VehicleCard(
          name: vehicle['name'] as String,
          description: vehicle['description'] as String,
          image: vehicle['image'] as Widget,
          errors: vehicle['errors'] as int,
        ),
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final String name;
  final String description;
  final Widget image;
  final int errors;

  const VehicleCard({
    super.key,
    required this.name,
    required this.description,
    required this.image,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
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
                const SizedBox(width: 10),
                image,
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: errors > 0 ? Colors.red[100] : Colors.green[50],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle,
                          color: errors > 0 ? Colors.red : Colors.green,
                          size: 10),
                      const SizedBox(width: 10),
                      Text(
                        '$errors Errors',
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
