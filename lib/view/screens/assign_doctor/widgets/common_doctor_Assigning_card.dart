// ignore: file_names
import 'dart:developer';

import 'package:doctor_visit/controller/assigned_doctor_controller/assigned_doctor_controller.dart';
import 'package:doctor_visit/controller/home_screen_controller/home_screen_controller.dart';
import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommonDoctorAssigningCard extends ConsumerWidget {
  final int indexGet;
  final String name;
  final String assignedBy;
  final bool? isClicked;
  final int? drID;
  final String initial;
  final bool isSelected;
  final bool? isEdit;
  final VoidCallback? onEdit;

  const CommonDoctorAssigningCard({
    super.key,
    this.isSelected = false,
    this.isClicked = false,
    this.drID,
    required this.name,
    required this.assignedBy,

    required this.initial,

    required this.indexGet,
    this.isEdit,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  Example: you can watch providers here if needed
    ref.watch(homeScreenProvider);
    final assignDoctorState = ref.watch(assignedScreenProvider);
    final assignDoctorController = ref.read(assignedScreenProvider.notifier);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {},
      child: Container(
        //margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected == true
              ? const Color.fromARGB(255, 251, 157, 151)
              : AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 1,
            color: (assignedBy.isNotEmpty)
                // ignore: deprecated_member_use
                ? Colors.red.withOpacity(.20)
                : Colors.green.withValues(alpha: .20),
          ),
          boxShadow: [
            BoxShadow(
              color: (assignedBy.isNotEmpty)
                  // ignore: deprecated_member_use
                  ? Colors.red.withOpacity(.20)
                  : Colors.green.withValues(alpha: .20),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: (assignedBy.isNotEmpty)
                  // ignore: deprecated_member_use
                  ? Colors.red.withOpacity(.20)
                  : Colors.green.withValues(alpha: .20),
              // blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 5,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.appLightRed,
                child: Text(
                  initial.toUpperCase(),
                  style: AppTextStyles.anekMalayalam(
                    color: Color(0xFFE53935),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  //spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name.isNotEmpty == true
                                ? name[0].toUpperCase() + name.substring(1)
                                : '',
                            textAlign: TextAlign.start,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.anekMalayalam(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Spacer(),
                        isClicked != null
                            ? InkWell(
                                onTap: () {
                                  log('hai');
                                  assignDoctorController.addDoctorRemove(drID!);
                                },
                                child: Icon(
                                  assignDoctorState.selectedList.contains(drID)
                                      ? Icons.check_box_outlined
                                      : Icons.check_box_outline_blank,
                                  size: 30,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    if (assignedBy.isNotEmpty)
                      Text(
                        "Assigned to ${assignedBy.isNotEmpty == true ? assignedBy[0].toUpperCase() + assignedBy.substring(1) : ''}",
                        style: AppTextStyles.anekMalayalam(
                          color: Colors.orange.shade700,
                        ),
                      ),

                    if (isEdit == null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: (assignedBy.isNotEmpty)
                                  ? Colors.red
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              (assignedBy.isNotEmpty)
                                  ? 'Completed'
                                  : 'Available',
                              style: AppTextStyles.anekMalayalam(
                                color: AppColors.appWhite,

                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (isEdit != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: (isEdit == true) ? onEdit : () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: (isEdit == false)
                                    ? Colors.red
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                (isEdit == true) ? 'Delete' : 'Completed',
                                style: AppTextStyles.anekMalayalam(
                                  color: AppColors.appWhite,

                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              //Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
