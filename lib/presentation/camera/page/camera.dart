import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';
import '../widgets/camera_body.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({
    super.key,
    required this.camera,
    required this.addImage,
  });

  final CameraDescription camera;
  final Function(XFile) addImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: true,
        title: Text(
          'Camera',
          style: AppText.pageTitleText.copyWith(color: AppColors.headingText),
        ),
      ),
      body: Center(
        child: CameraPageBody(camera: camera, addImage: addImage),
      ),
    );
  }
}
