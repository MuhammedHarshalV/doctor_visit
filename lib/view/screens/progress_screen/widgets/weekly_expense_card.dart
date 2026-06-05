import 'package:doctor_visit/controller/expense_controller/expense_controller.dart';
import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WeeklyExpenseCard extends ConsumerWidget {
  const WeeklyExpenseCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(dayExpenseProvider);
    final progressController = ref.read(dayExpenseProvider.notifier);
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
              color: AppColors.appTextFieldRed,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  progressState
                          .weeklyExpenseHistory
                          .first
                          .expenseList![progressState.weeklyListIndex]
                          .date ??
                      '',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.appPrimaryRed,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(
            DateFormat('EEEE').format(
              DateTime.parse(
                progressState
                        .weeklyExpenseHistory
                        .first
                        .expenseList![progressState.weeklyListIndex]
                        .date ??
                    '',
              ),
            ),
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
                onPressed: () {
                  progressController.weeklyListChangeIcrease();
                },
                icon: Icon(Icons.chevron_left, size: 32),
                color: AppColors.appBlack,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(), // Removes default extra padding
              ),

              Text(
                "₹${progressState.weekEotalExpense}",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.appBlack,
                  letterSpacing: 0.5,
                ),
              ),

              IconButton(
                onPressed: () {
                  progressController.weeklyListChangeDecrease();
                },
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
