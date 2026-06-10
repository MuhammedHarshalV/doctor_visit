import 'package:doctor_visit/controller/expense_controller/expense_controller.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/category_widget.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/food_card.dart';
import 'package:doctor_visit/view/widgets/common_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TotalSpentCard extends ConsumerWidget {
  const TotalSpentCard({super.key});
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
        progressController.updateISExpanded(!progressState.isExpanded);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          //color: const Color(0xFFFFEBEE), // Soft Red Background
          color: AppColors.appWhite,
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
                  "Total Spent Today",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  progressState.totalExpense.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appPrimaryRed,
                  ),
                ),
                Icon(
                  progressState.isExpanded
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  size: 30,
                ),
              ],
            ),
            if (progressState.isExpanded == true) SizedBox(height: 10),

            if (progressState.isExpanded == true &&
                progressState.todayExpenseList.isNotEmpty)
              SizedBox(
                child: Column(
                  spacing: 7,
                  children: List.generate(
                    progressState.todayExpenseList.length,
                    (index) => FoodCard(
                      isWeekly: false,
                      title:
                          progressState.todayExpenseList[index].expNote ??
                          'Not Mentioned',
                      description: progressState.todayExpenseList.isEmpty
                          ? 'Nothing'
                          : progressState.todayExpenseList[index].expDesc ==
                                null
                          ? 'Nothing'
                          : progressState.todayExpenseList[index].expDesc
                                .toString(),
                      price: progressState.todayExpenseList.isEmpty
                          ? '0'
                          : progressState.todayExpenseList[index].expAmt
                                .toString(),
                      imageUrl: '',
                      onEdit: () {
                        progressState.descriptionController.text =
                            progressState.todayExpenseList[index].expDesc ==
                                null
                            ? 'Nothing'
                            : progressState.todayExpenseList[index].expDesc
                                  .toString();
                        progressState.amountController.text =
                            progressState.todayExpenseList.isEmpty
                            ? '0'
                            : progressState.todayExpenseList[index].expAmt
                                  .toString();
                        progressController.updateCategory(
                          progressState.todayExpenseList[index].expNote ==
                                  'Food'
                              ? 1
                              : progressState.todayExpenseList[index].expNote ==
                                    'Petrol'
                              ? 2
                              : progressState.todayExpenseList[index].expNote ==
                                    'Travel'
                              ? 3
                              : 4,
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Consumer(
                              builder: (context, ref, _) {
                                final todayExpenseState = ref.watch(
                                  dayExpenseProvider,
                                );
                                final expenseController = ref.read(
                                  dayExpenseProvider.notifier,
                                );

                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Category",
                                            style: TextStyle(
                                              color: Color(0xFFE53935),
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                              isSelected:
                                                  todayExpenseState.category ==
                                                      1
                                                  ? true
                                                  : false,
                                              onTap: () {
                                                progressController
                                                    .updateCategory(1);
                                              },
                                            ),
                                            // CategoryWidget(),
                                            CategoryWidget(
                                              text: "Petrol",
                                              icon: Icons.local_gas_station,
                                              color: Colors.red,
                                              isSelected:
                                                  todayExpenseState.category ==
                                                      2
                                                  ? true
                                                  : false,
                                              onTap: () {
                                                progressController
                                                    .updateCategory(2);
                                              },
                                            ),
                                            CategoryWidget(
                                              text: "Travel",
                                              icon: Icons.car_repair_outlined,
                                              color: Colors.green,
                                              isSelected:
                                                  todayExpenseState.category ==
                                                      3
                                                  ? true
                                                  : false,
                                              onTap: () {
                                                progressController
                                                    .updateCategory(3);
                                              },
                                            ),
                                            CategoryWidget(
                                              text: "Other",
                                              icon: Icons.more_horiz,
                                              color: Colors.grey,
                                              isSelected:
                                                  todayExpenseState.category ==
                                                      4
                                                  ? true
                                                  : false,
                                              onTap: () {
                                                progressController
                                                    .updateCategory(4);
                                              },
                                            ),
                                          ],
                                        ),
                                        CommonTitleText(title: "Description"),
                                        TextFormField(
                                          controller: progressState
                                              .descriptionController,
                                          maxLines: 4,
                                          maxLength: 1000,
                                          decoration: _inputDecoration(''),
                                        ),
                                        CommonTitleText(title: "Amount"),
                                        TextFormField(
                                          controller: todayExpenseState
                                              .amountController,
                                          // maxLines: 4,
                                          //maxLength: 1000,
                                          decoration: _inputDecoration(
                                            progressState
                                                .todayExpenseList[index]
                                                .expDesc
                                                .toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: TextButton(
                                        onPressed: () {
                                          expenseController.editExpense(
                                            context: context,
                                            expenseKey: todayExpenseState
                                                .todayExpenseList[index]
                                                .expKey
                                                .toString(),
                                            expenseAmount: todayExpenseState
                                                .amountController
                                                .text,
                                            expenseDiscr: todayExpenseState
                                                .descriptionController
                                                .text,
                                            expenseNote:
                                                todayExpenseState.category == 1
                                                ? 'Food'
                                                : todayExpenseState.category ==
                                                      2
                                                ? 'Petrol'
                                                : todayExpenseState.category ==
                                                      3
                                                ? 'Travel'
                                                : 'Other',
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              AppColors.appPrimaryRed,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                        child:
                                            todayExpenseState.isEditLoading ==
                                                true
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color:
                                                            AppColors.appWhite,
                                                      ),
                                                ),
                                              )
                                            : Text(
                                                "Submit",
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
                              },
                            );
                          },
                        );
                      },
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
      fillColor: Color.fromARGB(255, 245, 194, 113),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
