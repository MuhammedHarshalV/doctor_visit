import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WeeklyExpenseDateCard extends ConsumerWidget {
  final String date;
  final VoidCallback onTapDecrease;
  final VoidCallback onTapIncrease;
  final String? weeklyExpense;

  const WeeklyExpenseDateCard({
    super.key,
    required this.date,
    required this.onTapDecrease,
    required this.onTapIncrease,
    this.weeklyExpense,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity, // Adjust width as needed
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      decoration: BoxDecoration(
        // color: AppColors.appYellow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Date Range Dropdown Chip ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.appPrimaryRed,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  date,

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.appWhite,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(
            DateFormat('EEEE').format(DateTime.parse(date)),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.appPrimaryRed,
            ),
          ),

          const SizedBox(height: 5),

          // --- Amount & Navigation Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onTapIncrease,
                icon: Icon(Icons.chevron_left, size: 32),
                color: AppColors.appBlack,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(), // Removes default extra padding
              ),

              if (weeklyExpense != null)
                Text(
                  weeklyExpense ?? '0',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appBlack,
                    letterSpacing: 0.5,
                  ),
                ),

              IconButton(
                onPressed: onTapDecrease,
                icon: const Icon(Icons.chevron_right, size: 32),
                color: Colors.black,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
