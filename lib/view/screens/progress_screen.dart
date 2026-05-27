import 'package:doctor_visit/controller/expense_controller/expense_controller.dart';
import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/widgets/common_appbar.dart';
import 'package:doctor_visit/view/widgets/common_title_text.dart';
import 'package:doctor_visit/view/widgets/expense_History_card.dart';
import 'package:doctor_visit/view/widgets/expense_add_card.dart';
import 'package:doctor_visit/view/widgets/today_expense_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(dayExpenseProvider);
    final progressController = ref.read(dayExpenseProvider.notifier);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.appPrimaryRed,
        statusBarIconBrightness: Brightness.dark, // Android icons
        statusBarBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.appWhite,
          appBar: const CommonAppBar(
            title: "HealthCare",
            subtitle: "Welcome back",
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Progress",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Today's visit summary",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  buildMainProgressCard(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      buildStatCard(
                        "Completed",
                        "2",
                        Icons.done_all,
                        Colors.green,
                        Colors.green.shade50,
                      ),
                      const SizedBox(width: 12),
                      buildStatCard(
                        "Upcoming",
                        "4",
                        Icons.access_time,
                        Colors.orange,
                        Colors.orange.shade50,
                      ),
                      const SizedBox(width: 12),
                      buildStatCard(
                        "Total",
                        "6",
                        Icons.group,
                        Colors.redAccent,
                        Colors.red.shade50,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  TotalSpentCard(),
                  const SizedBox(height: 16),
                  ExpenseFormCard(),
                  const SizedBox(height: 16),
                  ExpenseHistoryCard(),
                  SizedBox(height: 70),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required String label,
    required String hint,
    required IconData icon,
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

Widget buildStatCard(
  String label,
  String value,
  IconData icon,
  Color iconColor,
  Color bgColor,
) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: bgColor,
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    ),
  );
}

Widget buildMainProgressCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: const Color(0xFFE53935), // Primary Red
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFE53935).withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        const Text(
          "33%",
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
            value: 0.33,
            minHeight: 10,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ],
    ),
  );
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
