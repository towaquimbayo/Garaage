import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garaage/domain/entities/user.dart';
import 'package:garaage/presentation/profile/bloc/profile_cubit.dart';

import '../../../core/config/assets/app_images.dart';
import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';
import '../../../core/error/error_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @TODO: Replace with DB / Bloc data
  Map<String, dynamic> vehicle = {
    'name': 'Honda Civic',
    'description': '2021 Sport Hybrid Edition',
    'image': Image.asset(
      AppImages.hondaCivic,
      fit: BoxFit.contain,
      height: 70,
    ),
    'errors': 0,
  };

  // Get user data from Firestore

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().getUser();
    return Scaffold(
      appBar: MyAppBar(
        actions: true,
        title: BlocBuilder<ProfileCubit, ProfileState>(
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
            String? firstName;
            if (user != null) {
              firstName = user?.firstName;
            }
            return Text(
              'Welcome $firstName',
              style:
                  AppText.pageTitleText.copyWith(color: AppColors.headingText),
            );
          },
        ),
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
