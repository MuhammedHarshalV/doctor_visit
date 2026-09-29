import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/main.dart';
import 'package:doctor_visit/view/screens/visit_completion_screen/gps_camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static Future<String?> imageToBase64(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      final List<int> bytes = await imageFile.readAsBytes();
      final String base64Str = base64Encode(bytes);

      log(" Base64 length : ${base64Str.length}");
      log(
        " Base64 KB     : ${(base64Str.length / 1024).toStringAsFixed(1)} KB",
      );

      return base64Str;
    } catch (e) {
      log(" imageToBase64 Error: $e");
      return null;
    }
  }

  static Uint8List? base64ToBytes(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    try {
      return base64Decode(base64String);
    } catch (e) {
      log(" base64ToBytes Error: $e");
      return null;
    }
  }

  static Future<XFile?> pickImage({
    required bool isSelfie,
    required BuildContext context,
  }) async {
    final ImagePicker picker = ImagePicker();

    if (isSelfie) {
      return await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 10,
        maxWidth: 500,
        maxHeight: 500,
      );
    } else {
      // Show options: Camera / Gallery
      return await showModalBottomSheet<XFile?>(
        context: context,
        backgroundColor: AppColors.appWhite,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () async {
                    final image = await picker.pickImage(
                      source: ImageSource.camera,
                      preferredCameraDevice: CameraDevice.rear,
                      imageQuality: 10,
                      maxWidth: 500,
                      maxHeight: 500,
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, image);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    final image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 10,
                      maxWidth: 500,
                      maxHeight: 500,
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, image);
                  },
                ),
                SizedBox(height: 130),
              ],
            ),
          );
        },
      );
    }
  }

  static Future<XFile?> pickSelfieWithDetails({
    required BuildContext context,
  }) async {
    try {
      final File? image = await Navigator.push<File>(
        context,
        MaterialPageRoute(builder: (_) => const GpsCameraScreen()),
      );

      if (image == null) {
        return null;
      }

      return XFile(image.path);
    } catch (e) {
      debugPrint('Selfie capture error: $e');
      return null;
    }
  }
}
