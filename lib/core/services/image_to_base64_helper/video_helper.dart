import 'dart:io';

import 'package:doctor_visit/view/screens/visit_completion_screen/video_capture_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoHelper {
  static Future<XFile?> videoWithDetails({
    required BuildContext context,
    required bool isSelfie,
  }) async {
    try {
      final File? video = await Navigator.push<File>(
        context,
        MaterialPageRoute(
          builder: (_) => GpsVideoCameraScreen(isSelfie: isSelfie),
        ),
      );

      if (video == null) {
        return null;
      }

      return XFile(video.path);
    } catch (e) {
      debugPrint('Video capture error: $e');
      return null;
    }
  }
}
