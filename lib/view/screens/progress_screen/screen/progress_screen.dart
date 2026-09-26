import 'package:doctor_visit/controller/expense_controller/expense_controller.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/routes/app_route_names.dart';
import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/main_progress_card.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/row_stat_card.dart';
import 'package:doctor_visit/view/widgets/common_appbar.dart';

import 'package:doctor_visit/view/screens/progress_screen/widgets/expense_history_card.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/expense_add_card.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/today_expense_card.dart';
import 'package:doctor_visit/view/widgets/common_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProgressScreen extends ConsumerWidget {
  ProgressScreen({super.key});

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
                    Text(
                      "Progress",
                      style: AppTextStyles.anekMalayalam(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Today's visit summary",
                      style: AppTextStyles.anekMalayalam(color: Colors.grey),
                    ),
                    if (AppConstants.isProAssign == true) SizedBox(height: 16),
                    if (AppConstants.isProAssign == true)
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        onTap: () {
                          context.pushNamed(AppRouteNames.assignedScreen.name);
                        },

                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.appPrimaryRed),
                            // color: AppColors.appBlue.withOpacity(.7),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Assign Doctors',
                                  style: AppTextStyles.anekMalayalam(
                                    color: AppColors.appPrimaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_outward_sharp,
                                  color: AppColors.appPrimaryRed,
                                ),
                              ],
                            ),
                          ),
                        ),
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
                    if (AppConstants.isHiTech == false)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.appGrey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),

                              CommonTitleText(title: "Start km"),

                              TextFormField(
                                controller:
                                    progressController.startKmController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}'),
                                  ),
                                ],
                                // maxLines: 4,
                                //maxLength: 1000,
                                decoration: _inputDecoration('Enter km'),
                              ),

                              const SizedBox(height: 10),

                              CommonTitleText(title: "End km"),

                              TextFormField(
                                controller: progressController.endKmController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}'),
                                  ),
                                ],
                                // maxLines: 4,
                                //maxLength: 1000,
                                decoration: _inputDecoration('Enter km'),
                              ),

                              const SizedBox(height: 10),
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap:
                                    progressController
                                            .startKmController
                                            .text
                                            .isEmpty &&
                                        progressController
                                            .endKmController
                                            .text
                                            .isEmpty
                                    ? () {}
                                    : () async {
                                        await progressController.kmEnterApi(
                                          startKm: num.tryParse(
                                            progressController
                                                .startKmController
                                                .text,
                                          ),
                                          endKm: num.tryParse(
                                            progressController
                                                .endKmController
                                                .text,
                                          ),
                                          context: context,
                                        );
                                      },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.appPrimaryRed,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: progressState.isKmStart
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: AppColors.appWhite,
                                                    ),
                                              ),
                                            )
                                          : Text(
                                              'Submit',
                                              style:
                                                  AppTextStyles.anekMalayalam(
                                                    color: AppColors.appWhite,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 17,
                                                  ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.anekMalayalam(),
      filled: true,
      fillColor: AppColors.appTextFieldRed,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
