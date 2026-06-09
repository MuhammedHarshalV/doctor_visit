// ignore: file_names
import 'package:doctor_visit/controller/expense_controller/expense_controller.dart';
import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/food_card.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/weekly_expense_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseHistoryCard extends ConsumerWidget {
  const ExpenseHistoryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(dayExpenseProvider);
    final progressController = ref.read(dayExpenseProvider.notifier);
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,

      onTap: () {
        progressController.updateISExpandedHistory(
          !progressState.isExpandedHistory,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.appWhite, // Soft Red Background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.appGrey),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.appPrimaryRed,
                ),
                SizedBox(width: 12),
                Text(
                  "Expense History",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Spacer(),

                Icon(
                  progressState.isExpandedHistory
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  size: 30,
                ),
              ],
            ),

            if (progressState.isExpandedHistory == true) SizedBox(height: 10),
            if (progressState.isExpandedHistory == true &&
                progressState.weeklyExpenseSeperatedDate.isNotEmpty)
              WeeklyExpenseCard(),
            if (progressState.isExpandedHistory == true) SizedBox(height: 10),

            if (progressState.isExpandedHistory == true &&
                progressState.weeklyExpenseSeperatedDate.isNotEmpty)
              SizedBox(
                child: Column(
                  spacing: 7,
                  children: List.generate(
                    progressState
                        .weeklyExpenseSeperatedDate[progressState
                            .weeklyListIndex]
                        .expenses!
                        .length,
                    (index) => FoodCard(
                      isWeekly: true,
                      title:
                          progressState
                              .weeklyExpenseSeperatedDate[progressState
                                  .weeklyListIndex]
                              .expenses![index]
                              .expNote ??
                          '',
                      description:
                          progressState
                              .weeklyExpenseSeperatedDate[progressState
                                  .weeklyListIndex]
                              .expenses![index]
                              .expDesc ??
                          '',
                      price: progressState
                          .weeklyExpenseSeperatedDate[progressState
                              .weeklyListIndex]
                          .expenses![index]
                          .expAmt
                          .toString(),
                      imageUrl: '',
                      onEdit: () {},
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
