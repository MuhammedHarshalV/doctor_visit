import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';

class MainProgressCard extends StatelessWidget {
  final String percentage;
  final num value;

  const MainProgressCard({
    super.key,
    required this.percentage,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.appPrimaryRed, // Primary Red
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.appPrimaryRed.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "$percentage %",
            style:  AppTextStyles.anekMalayalam(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
           Text(
            "Visits Completed",
            style:  AppTextStyles.anekMalayalam(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value.toDouble(),
              minHeight: 10,
              // ignore: deprecated_member_use
              backgroundColor: AppColors.appWhite.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.appWhite),
            ),
          ),
        ],
      ),
    );
  }
}
