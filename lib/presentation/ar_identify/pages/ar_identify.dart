import 'package:flutter/material.dart';

import '../../../common/widgets/my_app_bar.dart';

class ARIdentifyPage extends StatelessWidget {
  const ARIdentifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(
        leading: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Text('Welcome to the AR Identify Page'),
      ),
    );
  }
}