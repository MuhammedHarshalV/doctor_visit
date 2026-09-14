import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:go_router/go_router.dart';

class CommonAlertDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onEdit;
  const CommonAlertDialog({super.key, required this.message, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.appWhite,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: AppTextStyles.anekMalayalam(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () async {
              if (onEdit != null) {
                onEdit!();
              } else {
                context.pop();
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.appPrimaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              "OK",
              style: AppTextStyles.anekMalayalam(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
