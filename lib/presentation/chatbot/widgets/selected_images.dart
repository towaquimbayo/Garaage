import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_colors.dart';

/// A stateless widget that displays a list of selected images with an option to remove them.
class SelectedImages extends StatelessWidget {
  SelectedImages({
    Key? key,
    required List<XFile?> pickedImages,
    required this.size,
    required this.removeImage,
  })  : _pickedImages = pickedImages,
        super(key: key);

  /// Height of the container displaying the images.
  final double size;

  /// List of picked images to display.
  final List<XFile?> _pickedImages;

  /// Callback function to remove an image at a given index.
  final Function(int) removeImage;

  /// Loads the images as a list of byte arrays.
  Future<List<Uint8List>> _loadImages() async {
    return await Future.wait(
      _pickedImages.where((file) => file != null).map((file) async {
        final bytes = await File(file!.path).readAsBytes();
        return bytes;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Uint8List>>(
      future: _loadImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a progress indicator while images are loading.
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if there was a problem loading the images.
          return Center(child: Text('Error loading images'));
        } else {
          final selectedImages = snapshot.data!;
          return SizedBox(
            height: size * 0.4,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 5,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Dismissible(
                    direction: DismissDirection.down,
                    background: Container(
                      color: Colors.red,
                    ),
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      // Remove the image when it is dismissed.
                      removeImage(index);
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.memory(
                            selectedImages[index],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          height: 15,
                          width: 15,
                          child: GestureDetector(
                            onTap: () {
                              // Remove the image when the close button is tapped.
                              removeImage(index);
                            },
                            child: SvgPicture.asset(
                              AppIcons.bold['close-circle']!,
                              colorFilter: const ColorFilter.mode(
                                AppColors.warningDark,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: selectedImages.length,
              scrollDirection: Axis.horizontal,
            ),
          );
        }
      },
    );
  }
}
