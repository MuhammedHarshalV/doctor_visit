import 'package:doctor_visit/controller/expense_controller/expense_controller.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/view/screens/home_screen/widget/alert_dialog.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/category_widget.dart';
import 'package:doctor_visit/view/widgets/build_input_field.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/widgets/common_title_text.dart';
import 'package:intl/intl.dart';

class ExpenseFormCard extends ConsumerWidget {
  const ExpenseFormCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(dayExpenseProvider);
    final progressController = ref.read(dayExpenseProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        //  color: AppColors.appYellow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 211, 208, 208)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category",
              style: TextStyle(
                color: AppColors.appPrimaryRed,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                CategoryWidget(
                  text: "Food",
                  icon: Icons.fastfood,
                  color: Colors.orange,
                  isSelected: progressState.category == 1 ? true : false,
                  onTap: () {
                    progressController.updateCategory(1);
                  },
                ),
                // CategoryWidget(),
                CategoryWidget(
                  text: "Petrol",
                  icon: Icons.local_gas_station,
                  color: Colors.red,
                  isSelected: progressState.category == 2 ? true : false,
                  onTap: () {
                    progressController.updateCategory(2);
                  },
                ),
                CategoryWidget(
                  text: "Travel",
                  icon: Icons.car_repair_outlined,
                  color: Colors.green,
                  isSelected: progressState.category == 3 ? true : false,
                  onTap: () {
                    progressController.updateCategory(3);
                  },
                ),
                CategoryWidget(
                  text: "Other",
                  icon: Icons.more_horiz,
                  color: Colors.grey,
                  isSelected: progressState.category == 4 ? true : false,
                  onTap: () {
                    progressController.updateCategory(4);
                  },
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Amount Field
            CustomInputField(
              controller: progressState.amountController,
              label: "Amount (₹)",
              hint: "e.g. 250",
              icon: Icons.payments_outlined,
              isNumber: true,
            ),
            CommonTitleText(title: 'Bill (optional)'),
            GestureDetector(
              onTap: () {
                // camera
              },
              child: Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.appTextFieldRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 30),
                      SizedBox(height: 5),
                      Text("Tap to capture Bill"),
                    ],
                  ),
                ),
              ),
            ),

            // Note Field
            SizedBox(height: 20),
            CommonTitleText(title: 'Description (optional)'),
            TextFormField(
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: progressState.descriptionController,
              maxLines: 4,
              maxLength: 1000,
              decoration: _inputDecoration('any Description'),
            ),

            const SizedBox(height: 20),

            // Add Expense Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (progressState.amountController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          CommonAlertDialog(message: 'Amount Cannot be Empty'),
                    );
                  } else {
                    progressController.editExpense(
                      context: context,
                      employeeID: AppConstants.employeeID,
                      yearId: AppConstants.yearID,
                      expenseAmount: progressState.amountController.text,
                      expenseDiscr: progressState.descriptionController.text,
                      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      expenseNote: progressState.category == 1
                          ? 'Food'
                          : progressState.category == 2
                          ? 'Petrol'
                          : progressState.category == 3
                          ? 'Travel'
                          : 'Other',
                    );
                  }
                },
                // icon: const Icon(Icons.check_circle, color: Colors.white),
                label: progressState.isEditLoading == true
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.appWhite,
                          ),
                        ),
                      )
                    : Text(
                        "Add Expense",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appPrimaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,

      filled: true,
      fillColor: AppColors.appTextFieldRed,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
