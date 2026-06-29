import 'package:doctor_visit/controller/assigned_doctor_controller/assigned_doctor_controller.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/assign_doctor/widgets/common_doctor_assigning_card.dart';
import 'package:doctor_visit/view/screens/home_screen/widget/alert_dialog.dart';
import 'package:doctor_visit/view/screens/progress_screen/widgets/weekly_expense_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WeeklyAssignedDoctorsWidget extends ConsumerWidget {
  const WeeklyAssignedDoctorsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignedState = ref.watch(assignedScreenProvider);
    final assignedController = ref.read(assignedScreenProvider.notifier);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.appGrey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: WeeklyExpenseDateCard(
            date: assignedState.weeklyDate,

            onTapDecrease: () {
              assignedController.weeklyDateIncreasing();
            },
            onTapIncrease: () {
              assignedController.weeklyDateDecreasing();
            },
            weeklyExpense: assignedState.weeklyAssignList.length.toString(),
          ),
        ),
        SizedBox(height: 10),
        assignedState.weeklyAssignList.isNotEmpty
            ? Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    bool on = assignedController.isEditOn();
                    if (index == assignedState.weeklyAssignList.length) {
                      return const SizedBox(height: 10);
                    }
                    return CommonDoctorAssigningCard(
                      onEdit: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CommonAlertDialog(
                              message:
                                  'This will remove Dr. ${assignedState.weeklyAssignList[index].drName ?? ''} from the assigned doctors list for ${assignedState.weeklyDate}. Do you want to continue?',
                              onEdit: () async {
                                await assignedController.deteleAssigneddoctors(
                                  date: assignedState.weeklyDate,
                                  drID: assignedState
                                      .weeklyAssignList[index]
                                      .drId
                                      .toString(),
                                );

                                // ignore: use_build_context_synchronously
                                context.pop();
                              },
                            );
                          },
                        );
                      },
                      isEdit: on,
                      isClicked: null,
                      name: assignedState.weeklyAssignList[index].drName ?? '',
                      assignedBy: '',

                      initial:
                          assignedState.weeklyAssignList[index].drName?[0] ??
                          '',
                      indexGet: 0,
                    );
                  },

                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: assignedState.weeklyAssignList.length + 1,
                  // assignedState.doctorsList.length,
                ),
              )
            : Expanded(
                child: SizedBox(
                  child: Center(child: Text('No booked doctors found.')),
                ),
              ),
      ],
    );
  }
}
