import 'dart:developer';

import 'package:doctor_visit/controller/bottom_nav_screen/bottom_nav_controller.dart';
import 'package:doctor_visit/controller/doctor_visit_controller/doctor_visit_controller.dart';
import 'package:doctor_visit/controller/home_screen_controller/home_screen_controller.dart';
import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/widgets/common_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisitCompletionScreen extends ConsumerWidget {
  final int index;
  const VisitCompletionScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController locationController = TextEditingController();
    final TextEditingController feedbackController = TextEditingController();
    final doctorVisitState = ref.watch(doctorVisitProvider);
    final doctorVisitController = ref.read(doctorVisitProvider.notifier);
    final homeScreenController = ref.read(homeScreenProvider.notifier);
    final homeScreenState = ref.watch(homeScreenProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.appWhite,
        statusBarIconBrightness: Brightness.dark, // Android icons
        statusBarBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.appWhite,
          appBar: AppBar(
            backgroundColor: AppColors.appWhite,
            leading: Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: AppColors.appPrimaryRed,
                shape: BoxShape.circle, // or BoxShape.rectangle
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.appWhite,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  if (homeScreenState.isStartGoing == false) {
                    homeScreenController.updateIsGoing(index, 'Yes', true);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.appGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Start Going',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.appWhite,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              InkWell(
                onTap: () {
                  log("message");
                  log(homeScreenState.doctorsList[index].isGoing.toString());
                  if (homeScreenState.doctorsList[index].isGoing == 'Yes') {
                    log("Reached $index");
                    homeScreenController.updateIsReach(index, "Yes");
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: homeScreenState.doctorsList[index].isGoing == 'Yes'
                        ? AppColors.appPrimaryRed
                        : Color.fromARGB(255, 243, 163, 156),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Reached',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.appWhite,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                /// 🔴 COLOR PICKER

                /// 📍 LOCATION
                Expanded(
                  child: ListView(
                    children: [
                      CommonTitleText(title: "Location *"),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Send Your Current Location',
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: const Color(0xFFE53935),
                            size: 20,
                          ),
                          filled: true,
                          fillColor: const Color(
                            0xFFFFEBEE,
                          ), // Soft red background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// 🤳 SELFIE
                      CommonTitleText(title: "Selfie *"),
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
                                Text("Tap to capture selfie"),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// ⏰ TIME PICKER
                      CommonTitleText(title: "Start Time *"),
                      GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            doctorVisitController.setStartTime(time);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.appTextFieldRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            doctorVisitState.startTime == null
                                ? "Select time"
                                : doctorVisitState.startTime!.format(context),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      CommonTitleText(title: "End Time *"),
                      GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            doctorVisitController.setEndTime(time);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.appTextFieldRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            doctorVisitState.endTime == null
                                ? "Select time"
                                : doctorVisitState.endTime!.format(context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// 📝 FEEDBACK
                      CommonTitleText(title: "Feedback / Discussion"),
                      TextFormField(
                        controller: feedbackController,
                        maxLines: 4,
                        maxLength: 1000,
                        decoration: _inputDecoration("Enter your notes..."),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),

                /// 🔘 BUTTONS
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            19,
                            150,
                            150,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Consumer(
                                builder: (context, ref, _) {
                                  final visitState = ref.watch(
                                    doctorVisitProvider,
                                  );
                                  final visitController = ref.read(
                                    doctorVisitProvider.notifier,
                                  );

                                  return AlertDialog(
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CommonTitleText(title: "Reason"),
                                          TextFormField(
                                            controller: feedbackController,
                                            maxLines: 4,
                                            maxLength: 1000,
                                            decoration: _inputDecoration(
                                              "Enter the Reason...",
                                            ),
                                          ),
                                          CommonTitleText(
                                            title: "Select Time *",
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              final time = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              );
                                              if (time != null) {
                                                visitController
                                                    .setPostponedTime(time);
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(14),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColors.appTextFieldRed,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                visitState.postponedTime == null
                                                    ? "Select time"
                                                    : visitState.postponedTime!
                                                          .format(context),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: TextButton(
                                          onPressed: () {
                                            homeScreenController.updateDoctor(
                                              index,
                                              'Postponed',
                                              visitState.postponedTime!.format(
                                                context,
                                              ),
                                              false,
                                            );
                                            Navigator.of(context).pop();
                                            if (Navigator.canPop(context)) {
                                              Navigator.pop(
                                                context,
                                              ); // close page safely
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                AppColors.appPrimaryRed,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          child: Text(
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
                        child: const Text(
                          "Postponed",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              homeScreenState.doctorsList[index].isReach ==
                                  'Yes'
                              ? AppColors.appPrimaryRed
                              : const Color.fromARGB(255, 243, 163, 156),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () {
                          if (homeScreenState.doctorsList[index].isReach ==
                              "Yes") {
                            homeScreenController.updateDoctor(
                              index,
                              'Done',
                              '01:00 PM',
                              false,
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Completed",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,

      filled: true,
      fillColor: AppColors.appTextFieldRed,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
