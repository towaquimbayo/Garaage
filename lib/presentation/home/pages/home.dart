import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/config/assets/app_images.dart';
import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? uid;
  String firstname = '';

  // @TODO: Replace with DB / Bloc data
  Map<String, dynamic> vehicle = {
    'name': 'Honda Civic',
    'description': '2021 Sport Hybrid Edition',
    'image': Image.asset(
      AppImages.hondaCivic,
      fit: BoxFit.contain,
    ),
    'transmission': 'Auto',
    'numSeats': 5,
    'errors': 0,
    'fuelConsumed': 70,
    'totalFuel': 100,
  };

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    uid = user?.uid;
    if (uid != null) _getUserData();
  }

  // Get user data from Firestore
  void _getUserData() async {
    try {
      // @TODO: Replace with actual document ID
      DocumentSnapshot userDoc =
          await _db.collection('Users').doc('kXuoDoi8vO0jLUBOMhfO').get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          print("Firestore UserData: $userData\n");
          firstname = userData['firstName'] as String;
        });
      } else {
        print('User Document does not exist');
      }
    } catch (e) {
      print('Error getting user data from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        actions: true,
        title: Text(
          'Welcome $firstname',
          style: AppText.pageTitleText.copyWith(color: AppColors.headingText),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            VehicleCard(
              name: vehicle['name'] as String,
              description: vehicle['description'] as String,
              image: vehicle['image'] as Widget,
              errors: vehicle['errors'] as int,
              transmission: vehicle['transmission'] as String,
              numSeats: vehicle['numSeats'] as int,
            ),
            const SizedBox(height: 20),
            FuelConsumptionCard(
              currentConsumed: vehicle['fuelConsumed'] as int,
              totalConsumed: vehicle['totalFuel'] as int,
            ),
          ],
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
  final String transmission;
  final int numSeats;

  const VehicleCard({
    super.key,
    required this.name,
    required this.description,
    required this.image,
    required this.errors,
    required this.transmission,
    required this.numSeats,
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
                    color: errors > 0 ? Colors.red[100] : Colors.green[50],
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
                        color: errors > 0 ? Colors.red : Colors.green,
                        size: 10,
                      ),
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

class FuelConsumptionCard extends StatelessWidget {
  final int currentConsumed;
  final int totalConsumed;

  const FuelConsumptionCard({
    super.key,
    required this.currentConsumed,
    required this.totalConsumed,
  });

  // progress bar
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      LinearProgressIndicator(
        value: currentConsumed / totalConsumed,
        backgroundColor: AppColors.lightGrayMedium,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        semanticsLabel: 'Fuel Consumption',
        semanticsValue: '$currentConsumed / $totalConsumed',
        minHeight: 40,
        borderRadius: BorderRadius.circular(50),
      ),
      Positioned(
        left: 20,
        top: 0,
        bottom: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.broken['fuel']!,
              width: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.surface,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Fuel',
              style: AppText.bodyText.copyWith(color: AppColors.surface),
            ),
          ],
        ),
      ),
    ]);
  }
}
