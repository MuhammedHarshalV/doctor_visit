import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:doctor_visit/controller/doctor_visit_controller/doctor_visit_controller.dart';

import 'package:doctor_visit/controller/home_screen_controller/home_screen_controller.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/services/location_services/location_services.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/home_screen/widget/alert_dialog.dart';
import 'package:doctor_visit/view/widgets/common_image_container.dart';
import 'package:doctor_visit/view/widgets/common_title_text.dart';
import 'package:doctor_visit/core/services/image_to_base64_helper/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class VisitCompletionScreen extends ConsumerWidget {
  final int index;
  const VisitCompletionScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

          body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
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
                          homeScreenController.getDoctorsVisit();
                          context.pop();
                        },
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap:
                          homeScreenState.doctorsListAPI[index].drIsGoing ==
                              true
                          ? () {}
                          : () async {
                              bool isConnected =
                                  await checkInternetConnection();
                              log("1========${isConnected.toString()}");

                              if (isConnected) {
                                log("Internet ON");
                              } else {
                                log("2========${isConnected.toString()}");
                                log("Internet OFF");
                              }
                              bool isAnyStarted = homeScreenState.doctorsListAPI
                                  .any((element) => element.drIsGoing == true);

                              if ((homeScreenState
                                              .doctorsListAPI[index]
                                              .drIsGoing ==
                                          null ||
                                      homeScreenState
                                              .doctorsListAPI[index]
                                              .drIsGoing ==
                                          false) &&
                                  isConnected == true &&
                                  isAnyStarted == false) {
                                try {
                                  final String doctorID = homeScreenState
                                      .doctorsListAPI[index]
                                      .drId
                                      .toString();
                                  doctorVisitController.isGoingStart(
                                    doctorID: doctorID,
                                  );

                                  Position position =
                                      await getCurrentLocation();
                                  String currentTime = DateTime.now()
                                      .toIso8601String();
                                  String currentDate = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(DateTime.now());
                                  String mapUrl =
                                      "https://www.google.com/maps?q=${position.latitude},${position.longitude}";

                                  log("Time: $currentTime");
                                  log("Date: $currentDate");
                                  log("Lat: ${position.latitude}");
                                  log("Lng: ${position.longitude}");
                                  log(mapUrl);
                                  await doctorVisitController
                                      .isGoingAndCompletionLocationSend(
                                        isStart: true,
                                        base64Image: null,
                                        doctorID: doctorID,
                                        date: currentDate,
                                        startLocation: mapUrl,
                                        startTime: currentTime,
                                        endLocation: null,
                                        endTime: null,
                                        feedback: null,
                                        detKey: null,
                                        workstatus: null,
                                      );
                                  if (doctorVisitState.response.isEmpty) {
                                    await homeScreenController
                                        .getDoctorsVisit();
                                    doctorVisitController.updateResponse('');
                                    doctorVisitController.setStartTime(null);
                                  }
                                } catch (e) {
                                  log(
                                    "harshal==================${e.toString()}",
                                  );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          e.toString(),
                                          style: TextStyle(
                                            color: AppColors.appWhite,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        backgroundColor: Colors.blue,
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.only(
                                          bottom:
                                              MediaQuery.of(
                                                context,
                                              ).size.height -
                                              120,
                                          left: 16,
                                          right: 16,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } else if ((homeScreenState
                                              .doctorsListAPI[index]
                                              .drIsGoing ==
                                          null ||
                                      homeScreenState
                                              .doctorsListAPI[index]
                                              .drIsGoing ==
                                          false) &&
                                  isConnected == false) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      // padding: EdgeInsets.all(10),
                                      content: Text(
                                        "No internet connection. Please try again when the network is available.",
                                        style: TextStyle(
                                          color: AppColors.appBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: AppColors.appWhite,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height -
                                            120,
                                        left: 16,
                                        right: 16,
                                      ),
                                    ),
                                  );
                                }
                              } else if ((homeScreenState
                                              .doctorsListAPI[index]
                                              .drIsGoing ==
                                          null ||
                                      homeScreenState
                                              .doctorsListAPI[index]
                                              .drIsGoing ==
                                          false) &&
                                  isConnected == true &&
                                  isAnyStarted == true) {
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CommonAlertDialog(
                                      message:
                                          "You already have an active visit in progress. Please complete the current visit before starting a new one.",
                                    ),
                                  );
                                }
                              }
                              // update via Riverpod
                            },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color:
                              homeScreenState.doctorsListAPI[index].drIsGoing ==
                                  true
                              ? AppColors.appGreen.withOpacity(.5)
                              : AppColors.appGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: doctorVisitState.isLoading == true
                            ? Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.appWhite,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
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
                  ],
                ),
                SizedBox(height: 10),

                ///  LOCATION
                Expanded(
                  child: ListView(
                    children: [
                      ///  SELFIE
                      CommonTitleText(title: "Selfie *"),
                      GestureDetector(
                        onTap: () async {
                          //  Step 1 — Pick image
                          final XFile? image = await ImageHelper.pickImage(
                            isSelfie: true,
                            context: context,
                          );
                          if (image == null) return;

                          //  Step 2 — Convert to base64
                          final String? base64String =
                              await ImageHelper.imageToBase64(image.path);
                          if (base64String == null) return;

                          //  Step 3 — Convert to bytes for display
                          final Uint8List? bytes = ImageHelper.base64ToBytes(
                            base64String,
                          );
                          if (bytes == null) return;

                          //  Step 4 — Save to controller
                          doctorVisitController.updateImage(bytes);

                          log(
                            "Image ready. Base64 KB: ${(base64String.length / 1024).toStringAsFixed(1)}",
                          );
                          doctorVisitController.base64ToApiUpdate(base64String);
                          // log('harshal image : $base64String');
                        },
                        child: ImageContainer(
                          state: doctorVisitState,
                          controller: doctorVisitController,
                          imagePurpose: 'Selfie',
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// TIME PICKER
                      CommonTitleText(title: "Start Time *"),
                      GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors
                                        .appPrimaryRed, // selected hour/minute
                                    onPrimary: Colors.white, // text on selected
                                    onSurface: Colors.black, // normal text
                                    surface: Colors.white, // dialog background
                                  ),
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: Colors.white,
                                    hourMinuteColor: AppColors.appTextFieldRed,
                                    hourMinuteTextColor: AppColors.appBlack,
                                    dayPeriodColor: AppColors.appTextFieldRed,
                                    dayPeriodTextColor: AppColors.appBlack,
                                    dialBackgroundColor:
                                        AppColors.appTextFieldRed,
                                    dialHandColor: AppColors.appPrimaryRed,
                                    dialTextColor: AppColors.appBlack,
                                    entryModeIconColor: AppColors.appPrimaryRed,
                                    cancelButtonStyle: TextButton.styleFrom(
                                      foregroundColor: AppColors.appPrimaryRed,
                                    ),
                                    confirmButtonStyle: TextButton.styleFrom(
                                      foregroundColor: AppColors.appPrimaryRed,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
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
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors
                                        .appPrimaryRed, // selected hour/minute
                                    onPrimary: Colors.white, // text on selected
                                    onSurface: Colors.black, // normal text
                                    surface: Colors.white, // dialog background
                                  ),
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: Colors.white,
                                    hourMinuteColor: AppColors.appTextFieldRed,
                                    hourMinuteTextColor: AppColors.appBlack,
                                    dayPeriodColor: AppColors.appTextFieldRed,
                                    dayPeriodTextColor: AppColors.appBlack,
                                    dialBackgroundColor:
                                        AppColors.appTextFieldRed,
                                    dialHandColor: AppColors.appPrimaryRed,
                                    dialTextColor: AppColors.appBlack,
                                    entryModeIconColor: AppColors.appPrimaryRed,
                                    cancelButtonStyle: TextButton.styleFrom(
                                      foregroundColor: AppColors.appPrimaryRed,
                                    ),
                                    confirmButtonStyle: TextButton.styleFrom(
                                      foregroundColor: AppColors.appPrimaryRed,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
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
                        controller: doctorVisitState.feedbackController,
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
                          fixedSize: const Size(double.maxFinite, 50),
                          backgroundColor: const Color.fromARGB(
                            255,
                            19,
                            150,
                            150,
                          ),
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
                                            controller: doctorVisitState
                                                .feedbackController,
                                            maxLines: 4,
                                            maxLength: 1000,
                                            decoration: _inputDecoration(
                                              "Enter the Reason...",
                                            ),
                                          ),
                                          // CommonTitleText(
                                          //   title: "Select Time *",
                                          // ),
                                          // GestureDetector(
                                          //   onTap: () async {
                                          //     final time = await showTimePicker(
                                          //       context: context,
                                          //       initialTime: TimeOfDay.now(),
                                          //     );
                                          //     if (time != null) {
                                          //       visitController
                                          //           .setPostponedTime(time);
                                          //     }
                                          //   },
                                          //   child: Container(
                                          //     padding: const EdgeInsets.all(14),
                                          //     width: double.infinity,
                                          //     decoration: BoxDecoration(
                                          //       color:
                                          //           AppColors.appTextFieldRed,
                                          //       borderRadius:
                                          //           BorderRadius.circular(10),
                                          //     ),
                                          //     child: Text(
                                          //       visitState.postponedTime == null
                                          //           ? "Select time"
                                          //           : visitState.postponedTime!
                                          //                 .format(context),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: TextButton(
                                          onPressed: () async {
                                            if (visitState
                                                .feedbackController
                                                .text
                                                .isEmpty) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CommonAlertDialog(
                                                      message:
                                                          'Please mention Reason for postponed.',
                                                    ),
                                              );
                                            } else {
                                              bool isConnected =
                                                  await checkInternetConnection();
                                              log(
                                                "1========${isConnected.toString()}",
                                              );

                                              if (isConnected) {
                                                log("Internet ON");
                                              } else {
                                                log(
                                                  "2========${isConnected.toString()}",
                                                );
                                                log("Internet OFF");
                                              }

                                              if (isConnected == true) {
                                                try {
                                                  final doctorID =
                                                      homeScreenState
                                                          .doctorsListAPI[index];

                                                  String currentDate =
                                                      DateFormat(
                                                        'yyyy-MM-dd',
                                                      ).format(DateTime.now());

                                                  log("Date: $currentDate");

                                                  visitController
                                                      .isGoingAndCompletionLocationSend(
                                                        isCompleted: true,
                                                        doctorID: doctorID.drId
                                                            .toString(),
                                                        date: currentDate,
                                                        startLocation: null,
                                                        startTime: null,
                                                        endLocation: null,
                                                        endTime: null,
                                                        feedback: visitState
                                                            .feedbackController
                                                            .text,
                                                        detKey:
                                                            doctorID.drIsGoing ==
                                                                true
                                                            ? AppConstants
                                                                  .detKey
                                                            : null,
                                                        // AppConstants.detKey,
                                                        workstatus: '2',
                                                        base64Image: null,
                                                      );

                                                  await homeScreenController
                                                      .getDoctorsVisit();
                                                  visitController
                                                      .updateResponse('');
                                                  visitState.feedbackController
                                                      .clear();

                                                  // ignore: use_build_context_synchronously
                                                  context.pop();
                                                  // ignore: use_build_context_synchronously
                                                  context.pop();
                                                } catch (e) {
                                                  log(
                                                    "harshal==================${e.toString()}",
                                                  );

                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          e.toString(),
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .appWhite,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            Colors.blue,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        margin: EdgeInsets.only(
                                                          bottom:
                                                              MediaQuery.of(
                                                                context,
                                                              ).size.height -
                                                              120,
                                                          left: 16,
                                                          right: 16,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              }
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
                                          child: visitState.isLoading == true
                                              ? Text(
                                                  "Loading",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Text(
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
                        child: Text(
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
                          fixedSize: const Size(double.maxFinite, 50),
                          backgroundColor:
                              homeScreenState.doctorsListAPI[index].drIsGoing ==
                                  true
                              ? AppColors.appPrimaryRed
                              : const Color.fromARGB(255, 243, 163, 156),
                        ),
                        onPressed:
                            homeScreenState.doctorsListAPI[index].drIsGoing ==
                                true
                            ? () async {
                                bool isConnected =
                                    await checkInternetConnection();
                                log("1========${isConnected.toString()}");

                                if (isConnected) {
                                  log("Internet ON");
                                } else {
                                  log("2========${isConnected.toString()}");
                                  log("Internet OFF");
                                }

                                if (isConnected == true) {
                                  try {
                                    final String doctorID = homeScreenState
                                        .doctorsListAPI[index]
                                        .drId
                                        .toString();

                                    Position position =
                                        await getCurrentLocation();
                                    String currentTime = DateTime.now()
                                        .toIso8601String();
                                    String currentDate = DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(DateTime.now());
                                    String mapUrl =
                                        "https://www.google.com/maps?q=${position.latitude},${position.longitude}";

                                    log("Time: $currentTime");
                                    log("Date: $currentDate");
                                    log("Lat: ${position.latitude}");
                                    log("Lng: ${position.longitude}");
                                    log(mapUrl);
                                    final missingFields = <String>[];

                                    if (doctorVisitState.startTime == null) {
                                      missingFields.add('Start time');
                                    }
                                    if (doctorVisitState.endTime == null) {
                                      missingFields.add('End time');
                                    }
                                    if (doctorVisitState.base64Image.isEmpty) {
                                      missingFields.add('Selfie');
                                    }
                                    if (missingFields.isNotEmpty) {
                                      showDialog(
                                        // ignore: use_build_context_synchronously
                                        context: context,
                                        builder: (context) => CommonAlertDialog(
                                          message:
                                              'Please provide: ${missingFields.join(', ')}',
                                        ),
                                      );

                                      // All fields are available
                                      // Call API here
                                    } else {
                                      await doctorVisitController
                                          .isGoingAndCompletionLocationSend(
                                            isCompleted: true,
                                            doctorID: doctorID,
                                            date: currentDate,
                                            startLocation: mapUrl,
                                            startTime:
                                                doctorVisitState.startTime !=
                                                    null
                                                ? formatTimeOfDayToApi(
                                                    doctorVisitState.startTime!,
                                                  )
                                                : null,
                                            endLocation: mapUrl,
                                            endTime:
                                                doctorVisitState.endTime != null
                                                ? formatTimeOfDayToApi(
                                                    doctorVisitState.endTime!,
                                                  )
                                                : null,
                                            feedback: doctorVisitState
                                                .feedbackController
                                                .text,
                                            detKey: AppConstants.detKey,
                                            workstatus: '1',
                                            base64Image:
                                                doctorVisitState.base64toApi,
                                          );
                                      // ignore: use_build_context_synchronously
                                      context.pop();
                                      await homeScreenController
                                          .getDoctorsVisit();
                                      doctorVisitController.updateResponse('');
                                      doctorVisitState.feedbackController
                                          .clear();
                                    }
                                  } catch (e) {
                                    log(
                                      "harshal==================${e.toString()}",
                                    );

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            e.toString(),
                                            style: TextStyle(
                                              color: AppColors.appWhite,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor: Colors.blue,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.only(
                                            bottom:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height -
                                                120,
                                            left: 16,
                                            right: 16,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }
                              }
                            : () {},
                        child: doctorVisitState.isComplete == true
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.appWhite,
                                  strokeWidth: 2,
                                ),
                              )
                            : Center(
                                child: Text(
                                  "Completed",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
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

  //bytes image

  String formatTimeOfDayToApi(TimeOfDay time) {
    final now = DateTime.now();

    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    return dateTime.toIso8601String();
  }

  Future<bool> checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    log(connectivityResult.toString());

    // ignore: unrelated_type_equality_checks
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      return true;
    }
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
