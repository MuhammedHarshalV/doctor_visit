import 'dart:io';

import 'package:doctor_visit/controller/doctor_visit_controller/doctor_visit_controller.dart';
import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageByDetails extends ConsumerWidget {
  const ImageByDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorVisitState = ref.watch(doctorVisitProvider);
    final doctorVisitController = ref.read(doctorVisitProvider.notifier);
    return Stack(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.appTextFieldRed,
            borderRadius: BorderRadius.circular(12),
            image: doctorVisitState.imagePath.isNotEmpty
                ? DecorationImage(
                    image: FileImage(File(doctorVisitState.imagePath)),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Center(
            child: doctorVisitState.imagePath.isNotEmpty
                ? null
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 30),
                      SizedBox(height: 5),
                      Text(
                        "Tap to capture Selfie",
                        style: AppTextStyles.anekMalayalam(),
                      ),
                    ],
                  ),
          ),
        ),

        // Action buttons
        if (doctorVisitState.imagePath.isNotEmpty)
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
                      builder: (_) => Dialog(
                        child: InteractiveViewer(
                          child: Image.file(
                            File(doctorVisitState.imagePath),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
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
                    doctorVisitController.setImagePath('');
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
