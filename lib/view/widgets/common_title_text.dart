import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';

class CommonTitleText extends StatelessWidget {
  final String title;

  const CommonTitleText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          title,
          style: AppTextStyles.anekMalayalam(
            color: AppColors.appPrimaryRed,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
