import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPageBody extends StatefulWidget {
  final CameraDescription camera;
  final Function(XFile) addImage;

  const CameraPageBody(
      {super.key, required this.camera, required this.addImage});

  @override
  State<CameraPageBody> createState() => _CameraPageBodyState();
}

class _CameraPageBodyState extends State<CameraPageBody> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _imageFile == null ? _buildCameraPreview() : _buildImagePreview();
  }

  Widget _buildCameraPreview() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Expanded(
                child: CameraPreview(_cameraController),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _takePicture,
                  child: const Text('Take Picture'),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildImagePreview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Image.file(File(_imageFile!.path)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _retakePicture,
              child: const Text('Retake'),
            ),
            ElevatedButton(
              onPressed: _savePicture,
              child: const Text('Attach'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _cameraController.takePicture();
      setState(() {
        _imageFile = image;
      });
    } catch (e) {
      print(e);
    }
  }

  void _retakePicture() {
    setState(() {
      _imageFile = null;
    });
  }

  void _savePicture() {
    // Implement your save logic here
    // For now, we'll just show a snackbar

    widget.addImage(_imageFile!);
    Navigator.of(context).pop();
    // After saving, you might want to clear the preview
    setState(() {
      _imageFile = null;
    });
  }
}
