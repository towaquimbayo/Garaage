import 'package:flutter/material.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';

class DiagnosticsPage extends StatelessWidget {
  const DiagnosticsPage({super.key});

  // @TODO: Replace sample Error codes with DB / Bloc data
  static final errorCodes = [
    {
      'code': 'P0128',
      'description':
          'The engine coolant isn\'t reaching optimal temperature due to a stuck-open thermostat, causing rich fuel mixture, increased fuel consumption, and reduced performance.',
      'causes': [
        'Stuck-open thermostat',
        'Faulty coolant temperature sensor (CTS)',
        'Low coolant level',
        'Air in the cooling system',
      ],
      'solutions': [
        'Check the coolant level: Top up if needed.',
        'Bleed the cooling system. To remove trapped air.',
        'Test the thermostat: Replace if it fails to open and close properly.',
        'Inspect the coolant temperature sensor (CTS): Replace if faulty.',
      ],
      'partsNeeded': [
        {
          'name': 'Replacement thermostat',
          'price': 6.99,
          'vendor': 'AutoZone',
          'link':
              'https://www.autozone.com/cooling-heating-and-climate-control/thermostat/duralast-thermostat-15368/10007_0_0',
        },
        {
          'name': 'Coolant',
          'price': 14.99,
          'vendor': 'NAPA',
          'link': 'https://www.napaonline.com/en/p/ZERCLC1',
        }
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        actions: true,
        title: Text(
          'Diagnostics',
          style: AppText.pageTitleText.copyWith(color: AppColors.headingText),
        ),
      ),
      body: const Center(
        child: Text('Welcome to the Diagnostics Page'),
      ),
    );
  }
}}

class Error {
  final String code;
  final String description;
  final List<String> causes;
  final List<String> solutions;
  final List<Map<String, dynamic>> partsNeeded;

  const Error({
    required this.code,
    required this.description,
    required this.causes,
    required this.solutions,
    required this.partsNeeded,
  });

  factory Error.fromMap(Map<String, dynamic> map) {
    return Error(
      code: map['code'],
      description: map['description'],
      causes: List<String>.from(map['causes']),
      solutions: List<String>.from(map['solutions']),
      partsNeeded: List<Map<String, dynamic>>.from(map['partsNeeded']),
    );
  }
}

