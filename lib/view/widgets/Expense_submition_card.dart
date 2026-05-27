import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:doctor_visit/theme/colors/appcolors.dart';

class ExpenseHeader extends ConsumerWidget {
  const ExpenseHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense Cart",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Food, Petrol & travel",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        // FloatingActionButton.small(
        //   onPressed: () {},
        //   backgroundColor: const Color(0xFFE53935),
        //   child: const Icon(Icons.add, color: Colors.white),
        // ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.appPrimaryRed,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Submit Today Expense',
                style: TextStyle(
                  color: AppColors.appWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
