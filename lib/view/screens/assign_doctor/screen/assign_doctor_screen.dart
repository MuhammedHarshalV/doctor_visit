
import 'package:doctor_visit/controller/assigned_doctor_controller/assigned_doctor_controller.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/assign_doctor/widgets/common_doctor_assigning_card.dart';
import 'package:doctor_visit/view/screens/assign_doctor/widgets/date_area_container.dart';
import 'package:doctor_visit/view/screens/assign_doctor/widgets/search_container.dart';

import 'package:doctor_visit/view/screens/assign_doctor/widgets/weekly_assigned_widget.dart';

import 'package:doctor_visit/view/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AssignDoctorScreen extends ConsumerStatefulWidget {
  const AssignDoctorScreen({super.key});
  @override
  ConsumerState<AssignDoctorScreen> createState() => _AssignDoctorScreenState();
}

class _AssignDoctorScreenState extends ConsumerState<AssignDoctorScreen> {
  late ScrollController scrollController;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    scrollController.addListener(() {
      final direction = scrollController.position.userScrollDirection;

      if (direction == ScrollDirection.reverse) {
        // Scrolling DOWN
        ref.read(assignedScreenProvider.notifier).updateScrollStatus(true);
      } else if (direction == ScrollDirection.forward) {
        // Scrolling UP
        ref.read(assignedScreenProvider.notifier).updateScrollStatus(false);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assignedState = ref.watch(assignedScreenProvider);
    final assignedController = ref.read(assignedScreenProvider.notifier);

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
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        // border: Border.all(
                        //   color: AppColors.appPrimaryRed,
                        //   width: .5,
                        // ),
                        color: AppColors.appTextFieldRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                onTap: () async {
                                  assignedController.updateStateClass(
                                    clicked: 1,
                                  );
                                  ref
                                      .read(assignedScreenProvider.notifier)
                                      .updateScrollStatus(false);
                                  if (assignedState.areaSelected.isNotEmpty) {
                                    int areaid = assignedController
                                        .areaNametoareaId(
                                          areaName: assignedState.areaSelected,
                                        );
                                    await assignedController.assignedDoctorArea(
                                      areaID: areaid.toString(),
                                      date: assignedState.dateSelected,
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: AppColors.appBlue),
                                    borderRadius: BorderRadius.circular(10),
                                    color: assignedState.clicked == 1
                                        ? AppColors.appPrimaryRed
                                        : AppColors.appTextFieldRed,
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(13),
                                      child: Text(
                                        'New Assign',
                                        style: TextStyle(
                                          color: assignedState.clicked == 1
                                              ? AppColors.appWhite
                                              : AppColors.appPrimaryRed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                onTap: () async {
                                  assignedController.updateStateClass(
                                    clicked: 2,
                                  );
                                  ref
                                      .read(assignedScreenProvider.notifier)
                                      .updateScrollStatus(false);

                                  await assignedController
                                      .weeklyAssignedHistory();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    //border: Border.all(color: AppColors.appBlue),
                                    borderRadius: BorderRadius.circular(10),
                                    color: assignedState.clicked == 2
                                        ? AppColors.appPrimaryRed
                                        : AppColors.appTextFieldRed,
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(13),
                                      child: Text(
                                        'Assigned History',
                                        style: TextStyle(
                                          color: assignedState.clicked == 2
                                              ? AppColors.appWhite
                                              : AppColors.appPrimaryRed,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                    SizedBox(height: 10),
                    Expanded(
                      child: assignedState.clicked == 1
                          ? Column(
                              children: [
                                if (assignedState.isScrolled == false)
                                  DateAreaContainer(),
                                SizedBox(height: 10),
                                DoctorSearchWidget(
                                  searchController: searchController,
                                ),
                                SizedBox(height: 10),
                                assignedState.isloadDrList == true
                                    ? Expanded(
                                        child: SizedBox(
                                          child: Center(
                                            child: SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircularProgressIndicator(
                                                color: AppColors.appPrimaryRed,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : assignedState.doctorsList.isEmpty
                                    ? Expanded(
                                        child: SizedBox(
                                          child: Center(
                                            child: Text(
                                              'Select area to get results.',
                                            ),
                                          ),
                                        ),
                                      )
                                    : assignedState.searchText == 'Available'
                                    ? assignedState.freeList.isEmpty
                                          ? Expanded(
                                              child: SizedBox(
                                                child: Center(
                                                  child: Text(
                                                    'No Doctors are available.',
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Expanded(
                                              child: ListView.separated(
                                                physics:
                                                    AlwaysScrollableScrollPhysics(),
                                                controller: scrollController,
                                                itemBuilder: (context, index) {
                                                  if (index ==
                                                      assignedState
                                                          .freeList
                                                          .length) {
                                                    return const SizedBox(
                                                      height: 80,
                                                    );
                                                  }
                                                  return CommonDoctorAssigningCard(
                                                    drID:
                                                        assignedState
                                                            .freeList[index]
                                                            .drId ??
                                                        0,
                                                    isClicked: true,

                                                    name:
                                                        assignedState
                                                            .freeList[index]
                                                            .drName ??
                                                        '',
                                                    assignedBy:
                                                        assignedState
                                                            .freeList[index]
                                                            .assignedProName ??
                                                        '',

                                                    initial:
                                                        assignedState
                                                            .freeList[index]
                                                            .drName?[0] ??
                                                        '',
                                                    indexGet: 0,
                                                  );
                                                },

                                                separatorBuilder:
                                                    (context, index) =>
                                                        SizedBox(height: 10),
                                                itemCount:
                                                    assignedState
                                                        .freeList
                                                        .length +
                                                    1,
                                              ),
                                            )
                                    : assignedState.bookedList.isEmpty
                                    ? Expanded(
                                        child: SizedBox(
                                          child: Center(
                                            child: Text(
                                              'No booked doctors found.',
                                            ),
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: ListView.separated(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          controller: scrollController,
                                          itemBuilder: (context, index) {
                                            if (index ==
                                                assignedState
                                                    .bookedList
                                                    .length) {
                                              return const SizedBox(height: 80);
                                            }
                                            return CommonDoctorAssigningCard(
                                              isClicked: null,
                                              name:
                                                  assignedState
                                                      .bookedList[index]
                                                      .drName ??
                                                  '',
                                              assignedBy:
                                                  assignedState
                                                      .bookedList[index]
                                                      .assignedProName ??
                                                  '',

                                              initial:
                                                  assignedState
                                                      .bookedList[index]
                                                      .drName?[0] ??
                                                  '',
                                              indexGet: 0,
                                            );
                                          },

                                          separatorBuilder: (context, index) =>
                                              SizedBox(height: 10),
                                          itemCount:
                                              assignedState.bookedList.length +
                                              1,
                                        ),
                                      ),
                              ],
                            )
                          : WeeklyAssignedDoctorsWidget(),
                    ),
                  ],
                ),
              ),
              if (assignedState.selectedList.isNotEmpty &&
                  assignedState.clicked == 1)
                Positioned(
                  left: 90,
                  right: 90,
                  bottom: 10,
                  child: SafeArea(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await assignedController.assignDoctorsApi();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.appPrimaryRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: assignedState.isSaving == true
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.appWhite,
                                ),
                              )
                            : Text(
                                "Book Doctor",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
