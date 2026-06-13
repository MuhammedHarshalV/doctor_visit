import 'package:doctor_visit/controller/expense_controller/expense_controller.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/main_progress_card.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/row_stat_card.dart';
import 'package:doctor_visit/view/widgets/common_appbar.dart';

import 'package:doctor_visit/view/screens/progress_screen/widgets/expense_history_card.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/expense_add_card.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/today_expense_card.dart';
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
            child: RefreshIndicator(
              color: AppColors.appPrimaryRed, // spinner color
              backgroundColor: AppColors.appLightRed, // circle background
              strokeWidth: 2,
              onRefresh: () async {
                await progressController.iniatialCall();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Progress",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Today's visit summary",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    MainProgressCard(
                      percentage: progressState.progressPeercentage.isEmpty
                          ? '0'
                          : progressState.progressPeercentage.first.percentage
                                .toString(),
                      value: progressState.progressValue,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        StatCard(
                          label: "Completed",
                          value: progressState.progressPeercentage.isEmpty
                              ? '0'
                              : progressState
                                    .progressPeercentage
                                    .first
                                    .compltCount
                                    .toString(),

                          icon: Icons.done_all,
                          iconColor: Colors.green,
                          bgColor: Colors.green.shade50,
                        ),
                        const SizedBox(width: 12),
                        StatCard(
                          label: "Upcoming",
                          value: progressState.progressPeercentage.isEmpty
                              ? '0'
                              : progressState.progressPeercentage.first.upcoming
                                    .toString(),
                          icon: Icons.access_time,
                          iconColor: Colors.orange,
                          bgColor: Colors.orange.shade50,
                        ),
                        const SizedBox(width: 12),
                        StatCard(
                          label: "Total",
                          value: progressState.progressPeercentage.isEmpty
                              ? '0'
                              : progressState.progressPeercentage.first.total
                                    .toString(),
                          icon: Icons.group,
                          iconColor: Colors.redAccent,
                          bgColor: Colors.red.shade50,
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
      ),
    );
  }
}
