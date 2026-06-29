import 'package:doctor_visit/controller/assigned_doctor_controller/assigned_doctor_controller.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/assign_doctor/widgets/selection_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DateAreaContainer extends ConsumerWidget {
  const DateAreaContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignedState = ref.watch(assignedScreenProvider);
    final assignedController = ref.read(assignedScreenProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.appTextFieldRed,
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(
        //   width: 1,
        //   color: AppColors.appPrimaryRed
        //       .withOpacity(.5),
        // ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SelectionCard(
              context: context,
              title: assignedState.areaSelected.isNotEmpty
                  ? assignedState.areaSelected
                  : "Select Location",
              subtitle: assignedState.areaSelected.isEmpty
                  ? 'Select any Area'
                  : null,
              icon: Icons.location_on_outlined,
              item: assignedState.areaList.map((e) => e.desc ?? '').toList(),
              onTap: (p0) async {
                assignedController.updateStateClass(areaSelected: p0);
                int areaId = assignedController.areaNametoareaId(areaName: p0);
                await assignedController.assignedDoctorArea(
                  areaID: areaId.toString(),
                  date: assignedState.dateSelected,
                );
              },
            ),

            SizedBox(height: 10),

            SelectionCard(
              context: context,
              title: assignedState.dateSelected,
              subtitle: DateFormat(
                'EEEE',
              ).format(DateTime.parse(assignedState.dateSelected.toString())),
              icon: Icons.calendar_month_outlined,

              onTap: (p0) async {
                assignedController.updateStateClass(dateSelected: p0);
                if (assignedState.areaSelected.isNotEmpty) {
                  int areaId = assignedController.areaNametoareaId(
                    areaName: assignedState.areaSelected,
                  );
                  await assignedController.assignedDoctorArea(
                    areaID: areaId.toString(),
                    date: p0,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
