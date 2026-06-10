import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';

class AppMessage {
  static void show(BuildContext contexts, String message) {
    showDialog(
      context: contexts,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.appWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Alert",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              // const SizedBox(height: 15),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }
}
