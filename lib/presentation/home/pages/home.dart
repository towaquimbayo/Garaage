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
    'speed': 68,
    'rpm': 2731,
    'battery': 84,
    'oil': 59,
    'coolantCurrent': 90,
    'coolantDesired': 120,
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
            const SizedBox(height: 10),
            FuelConsumptionCard(
              currentConsumed: vehicle['fuelConsumed'] as int,
              totalConsumed: vehicle['totalFuel'] as int,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: VehicleStatsCard(
                    value: vehicle['speed'] as int,
                    icon: AppIcons.broken['speed']!,
                    mainLabel: 'Speed',
                    subLabel: 'km/h',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 6,
                  child: VehicleStatsCard(
                    value: vehicle['rpm'] as int,
                    icon: AppIcons.broken['rpm']!,
                    mainLabel: 'Engine RPM',
                    fixAlignment: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 6,
                  child: VehicleStatsCard(
                    value: vehicle['battery'] as int,
                    icon: AppIcons.broken['battery']!,
                    mainLabel: 'Car Battery',
                    postfix: '%',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: VehicleStatsCard(
                    value: vehicle['oil'] as int,
                    icon: AppIcons.broken['drop']!,
                    mainLabel: 'Oil',
                    postfix: '%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            VehicleStatsCard(
              value: vehicle['coolantCurrent'] as int,
              valueAlt: vehicle['coolantDesired'] as int,
              icon: AppIcons.broken['coolant']!,
              mainLabel: 'Coolant Temp',
              subLabel: 'current',
              subLabelAlt: 'desired',
              postfix: '°C',
            ),
            const SizedBox(height: 20),
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
        minHeight: 30,
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
          )
        ],
      ),
    );
  }
}
