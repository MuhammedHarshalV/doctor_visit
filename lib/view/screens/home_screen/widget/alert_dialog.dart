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
          children: [Text(message, textAlign: TextAlign.center)],
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
            child: const Text(
              "OK",
              style: TextStyle(
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
