import 'package:doctor_visit/controller/assigned_doctor_controller/assigned_doctor_controller.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/assign_doctor/widgets/drop_down_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorSearchWidget extends ConsumerWidget {
  final TextEditingController searchController;

  const DoctorSearchWidget({super.key, required this.searchController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignedState = ref.watch(assignedScreenProvider);
    final assignedController = ref.read(assignedScreenProvider.notifier);

    return Container(
      padding: const EdgeInsets.only(left: 10, top: 2, bottom: 2, right: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.appPrimaryRed.withValues(alpha: .3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // TextField
          Expanded(
            child: TextField(
              controller: searchController,
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onChanged: (value) {
                assignedController.updateStateClass(searchController: value);
                assignedController.searchDoctors();
              },
              style: TextStyle(
                // fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.appPrimaryRed,
              ),
              decoration: InputDecoration(
                hintText: 'Search Dr Name...',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.appPrimaryRed,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Right Container
          GestureDetector(
            onTapDown: (details) {
              final List<String> item = ['Available', 'Booked'];
              DropDownWidget.showDropDown(
                context,
                details.globalPosition,
                item,
                (value) async {
                  assignedController.updateStateClass(searchText: value);
                  if (assignedState.areaSelected.isNotEmpty) {
                    int areaId = assignedController.areaNametoareaId(
                      areaName: assignedState.areaSelected,
                    );
                    await assignedController.assignedDoctorArea(
                      areaID: areaId.toString(),
                      date: assignedState.dateSelected,
                    );
                    ref
                        .read(assignedScreenProvider.notifier)
                        .updateScrollStatus(false);
                  }
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.appPrimaryRed.withValues(alpha: .5),
                  width: 1,
                ),
                color: AppColors.appPrimaryRed,
                //.withOpacity(.5),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      assignedState.searchText,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.appWhite,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: AppColors.appWhite,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
