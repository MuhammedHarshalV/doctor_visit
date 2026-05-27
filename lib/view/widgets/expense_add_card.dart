import 'dart:developer';

import 'package:doctor_visit/controller/expense_controller/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/widgets/common_title_text.dart';

class ExpenseFormCard extends ConsumerStatefulWidget {
  const ExpenseFormCard({super.key});

  @override
  ConsumerState<ExpenseFormCard> createState() => _ExpenseFormCardState();
}

class _ExpenseFormCardState extends ConsumerState<ExpenseFormCard> {
  // Controllers outside build method
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('hai harshal Add expense Screen build');

    final progressState = ref.watch(dayExpenseProvider);
    final progressController = ref.read(dayExpenseProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 194, 113),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Category",
              style: TextStyle(
                color: Color(0xFFE53935),
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
            buildInputField(
              controller: amountController,
              label: "Amount (₹)",
              hint: "e.g. 250",
              icon: Icons.payments_outlined,
              isNumber: true,
            ),
            CommonTitleText(title: 'Bill (optional)'),
            GestureDetector(
              onTap: () {
                // TODO: open camera
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
            buildInputField(
              controller: noteController,
              label: "Note (optional)",
              hint: "e.g. Lunch near clinic",
              icon: Icons.description_outlined,
            ),

            const SizedBox(height: 20),

            // Add Expense Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  progressController.saveToHive(
                    typeOfExpense: progressState.category == 1
                        ? 'Food'
                        : progressState.category == 2
                        ? 'Petrol'
                        : progressState.category == 3
                        ? 'Travel'
                        : 'Other',
                    amount: amountController.text,
                    bill: '',
                    note: noteController.text,
                  );
                  amountController.clear();
                  noteController.clear();
                },
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text(
                  "Add Expense",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
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

  Widget buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool? isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.appPrimaryRed,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: isNumber == true ? TextInputType.number : null,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFFE53935), size: 20),
            filled: true,
            fillColor: const Color(0xFFFFEBEE), // Soft red background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class CategoryWidget extends StatelessWidget {
  //required String label,
  //   required IconData icon,
  //   required Color color,
  //   bool isSelected = false,
  final String text;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : color),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget categoryChip({
//   required String label,
//   required IconData icon,
//   required Color color,
//   bool isSelected = false,
// }) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     decoration: BoxDecoration(
//       color: isSelected ? Colors.orange : Colors.white,
//       borderRadius: BorderRadius.circular(20),
//       border: Border.all(color: Colors.grey.shade200),
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 16, color: isSelected ? Colors.white : color),
//         const SizedBox(width: 8),
//         Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.black87,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     ),
//   );
// }
