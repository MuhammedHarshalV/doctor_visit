import 'dart:typed_data';

import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    required this.state,
    required this.controller,
    required this.imagePurpose,
  });

  final dynamic state;
  final dynamic controller;
  final String imagePurpose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.appTextFieldRed,
            borderRadius: BorderRadius.circular(12),
            image: state.base64Image.isNotEmpty
                ? DecorationImage(
                    image: MemoryImage(state.base64Image),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Center(
            child: state.base64Image.isNotEmpty
                ? null
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 30),
                      SizedBox(height: 5),
                      Text("Tap to capture $imagePurpose"),
                    ],
                  ),
          ),
        ),

        // Action buttons
        if (state.base64Image.isNotEmpty)
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
                          child: Image.memory(
                            state.base64Image,
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
                    controller.updateImage(Uint8List(0));
                    controller.base64ToApiUpdate('');
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
