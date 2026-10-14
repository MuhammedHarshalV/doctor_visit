import 'dart:io';

import 'package:doctor_visit/controller/doctor_visit_controller/doctor_visit_controller.dart';
import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/visit_completion_screen/local_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoDetails extends ConsumerWidget {
  const VideoDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorVisitState = ref.watch(doctorVisitProvider);
    final doctorVisitController = ref.read(doctorVisitProvider.notifier);
    return Stack(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          //
          decoration: BoxDecoration(
            color: AppColors.appTextFieldRed,
            borderRadius: BorderRadius.circular(12),
            image: doctorVisitState.thumbnailPath.isNotEmpty
                ? DecorationImage(
                    image: FileImage(File(doctorVisitState.thumbnailPath)),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Center(
            child: doctorVisitState.videoPath.isNotEmpty
                ? null
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 30),
                      SizedBox(height: 5),
                      Text(
                        "Tap to capture video",
                        style: AppTextStyles.anekMalayalam(),
                      ),
                    ],
                  ),
          ),
        ),

        // Action buttons
        if (doctorVisitState.videoPath.isNotEmpty)
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: AppColors.appBlack.withOpacity(.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, color: AppColors.appWhite, size: 20),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withValues(alpha: .85),
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.black,
                          insetPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 40,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: AspectRatio(
                              aspectRatio: 9 / 16,
                              child: LocalVideoPlayer(
                                videoPath: doctorVisitState.videoPath,
                                autoPlay: true,
                                showControls: true,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: AppColors.appBlack.withOpacity(.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.visibility,
                      color: AppColors.appWhite,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                GestureDetector(
                  onTap: () {
                    doctorVisitController.setVideoPath('');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: AppColors.appPrimaryRed.withOpacity(.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete,
                      color: AppColors.appWhite,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
