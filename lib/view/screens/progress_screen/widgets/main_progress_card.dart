import 'package:doctor_visit/theme/colors/appcolors.dart';
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.appPrimaryRed, // Primary Red
        borderRadius: BorderRadius.circular(24),
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
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            "Visits Completed",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 20),
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
