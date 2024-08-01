import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_colors.dart';

class SelectedImages extends StatelessWidget {
  const SelectedImages(
      {super.key,
      required this.size,
      required this.selectedImages,
      required this.removeImage});

  final double size;
  final List<XFile?> selectedImages;
  final Function(int) removeImage;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size * 0.4,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5,
        ),
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder<Uint8List>(
            future: selectedImages[index]?.readAsBytes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error loading image');
              } else {
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Image.memory(snapshot.data!),
                      IconButton(
                        onPressed: () {
                          removeImage(index);
                        },
                        icon: SvgPicture.asset(
                          height: size * 0.1,
                          AppIcons.broken['forbidden']!,
                          colorFilter: const ColorFilter.mode(
                            AppColors.surface,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
        itemCount: selectedImages.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
