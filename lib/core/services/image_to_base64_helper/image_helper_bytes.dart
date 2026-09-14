import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelperBytes {
  static Future<XFile?> pickImage({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    return image;
  }
}
