import 'dart:developer';

import 'package:doctor_visit/controller/add_doctor_controller/add_doctor_controller.dart';
import 'package:doctor_visit/controller/bottom_nav_screen/bottom_nav_controller.dart';
import 'package:doctor_visit/controller/home_screen_controller/home_screen_controller.dart';
import 'package:doctor_visit/theme/colors/appcolors.dart';

import 'package:doctor_visit/view/widgets/common_appbar.dart';
import 'package:doctor_visit/view/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDoctorScreen extends ConsumerStatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  ConsumerState<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends ConsumerState<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController doctorPhoneController = TextEditingController();
  final TextEditingController doctorSpecialityController =
      TextEditingController();
  final TextEditingController doctorClinicController = TextEditingController();
  final TextEditingController doctorDiscussionController =
      TextEditingController();

  @override
  void dispose() {
    doctorNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addDoctorScreenWatch = ref.watch(addDoctorProvider);
    final addDoctorScreenRead = ref.read(addDoctorProvider.notifier);
    ref.watch(homeScreenProvider);
    ref.read(homeScreenProvider.notifier);
    final bottomNavNotifier = ref.read(bottomNavProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.appPrimaryRed,
        statusBarIconBrightness: Brightness.dark, // Android icons
        statusBarBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.appWhite,
          resizeToAvoidBottomInset: true,
          appBar: const CommonAppBar(
            title: "HealthCare",
            subtitle: "Welcome back",
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Form(
              key: _formKey,
              autovalidateMode: addDoctorScreenWatch.isSubmitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add Doctor",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Quickly register a doctor for today's visits",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    TopText(heading: 'Doctor Name *'),
                    SizedBox(height: 7),
                    TypeTextFormField(
                      hintText: 'Doctor Name',
                      textController: doctorNameController,
                      preIcon: Icon(
                        Icons.person_2_outlined,
                        color: AppColors.appPrimaryRed,
                      ),
                    ),
                    SizedBox(height: 5),
                    // Input Fields
                    // buildInputField(
                    //   label: "Doctor Name *",
                    //   hint: "e.g. Anjali Mehta",
                    //   icon: Icons.person_outline,
                    // ),
                    TopText(heading: 'Phone Number *'),
                    SizedBox(height: 7),
                    TypeTextFormField(
                      hintText: 'Phone Number',
                      textController: doctorPhoneController,
                      preIcon: Icon(
                        Icons.phone,
                        color: AppColors.appPrimaryRed,
                      ),
                      isNumber: true,
                    ),
                    SizedBox(height: 5),

                    // buildInputField(
                    //   label: "Phone Number *",
                    //   hint: "+91 90000 00000",
                    //   icon: Icons.phone_outlined,
                    // ),
                    // buildInputField(
                    //   label: "Speciality",
                    //   hint: "e.g. Cardiologist",
                    //   icon: Icons.medical_services_outlined,
                    // ),
                    TopText(heading: 'Speciality *'),
                    SizedBox(height: 7),
                    TypeTextFormField(
                      hintText: 'Speciality',
                      textController: doctorSpecialityController,
                      preIcon: Icon(
                        Icons.medical_information_outlined,
                        color: AppColors.appPrimaryRed,
                      ),
                    ),
                    SizedBox(height: 5),

                    TopText(heading: 'Clinic Name *'),
                    SizedBox(height: 7),
                    TypeTextFormField(
                      hintText: 'Clinic Name',
                      textController: doctorClinicController,
                      preIcon: Icon(
                        Icons.medical_services_outlined,
                        color: AppColors.appPrimaryRed,
                      ),
                    ),
                    // buildInputField(
                    //   label: "Clinic Name *",
                    //   hint: "e.g. Health Center",
                    //   icon: Icons.medical_services_outlined,
                    // ),
                    SizedBox(height: 5),

                    _sectionTitle("Discussion"),
                    TextFormField(
                      controller: doctorDiscussionController,
                      maxLines: 4,
                      maxLength: 1000,
                      decoration: _inputDecoration(""),
                    ),
                    BottomAppBar(
                      color: Colors.transparent,
                      elevation: 0,
                      child: SafeArea(
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              addDoctorScreenRead.setIsSubmitted(true);

                              if (_formKey.currentState!.validate()) {
                                // Only update state when form is valid

                                // await homeScreenRead.saveToHive(
                                //   name: doctorNameController.text,
                                //   phoneNumber: doctorPhoneController.text,
                                //   speciality: doctorSpecialityController.text,
                                //   timing: '01 PM',
                                //   status: 'Upcoming',
                                //   isStartGoing: 'No',
                                // );

                                log(
                                  "Add doctor Details :name =${doctorNameController.text}, phone =${doctorPhoneController.text},speciality =${doctorSpecialityController.text},clinic name =${doctorClinicController.text} ",
                                );
                                addDoctorScreenRead.setIsSubmitted(false);
                                bottomNavNotifier.setIndex(0);
                                doctorNameController.clear();
                                doctorPhoneController.clear();
                                doctorSpecialityController.clear();
                                doctorClinicController.clear();
                                doctorDiscussionController.clear();
                              } else {
                                log("Show errors ");
                              }
                            },
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Save Doctor",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              // foregroundColor: Colors.amber,
                              backgroundColor: const Color(0xFFE53935),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 70),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 55,
                    //   child: ElevatedButton.icon(
                    //     onPressed: () async {
                    //       addDoctorScreenRead.setIsSubmitted(true);

                    //       if (_formKey.currentState!.validate()) {
                    //         // Only update state when form is valid
                    //         await homeScreenRead.saveToHive(
                    //           name: doctorNameController.text,
                    //           phoneNumber: doctorPhoneController.text,
                    //           speciality: doctorSpecialityController.text,
                    //           timing: '01 PM',
                    //           status: 'Upcoming',
                    //         );

                    //         log(
                    //           "Add doctor Details :name =${doctorNameController.text}, phone =${doctorPhoneController.text},speciality =${doctorSpecialityController.text},clinic name =${doctorClinicController.text} ",
                    //         );
                    //         addDoctorScreenRead.setIsSubmitted(false);
                    //         bottomNavNotifier.setIndex(0);
                    //         doctorNameController.clear();
                    //         doctorPhoneController.clear();
                    //         doctorSpecialityController.clear();
                    //         doctorClinicController.clear();
                    //         doctorDiscussionController.clear();
                    //       } else {
                    //         log("Show errors ");
                    //       }
                    //     },
                    //     icon: const Icon(Icons.check_circle, color: Colors.white),
                    //     label: const Text(
                    //       "Save Doctor",
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xFFE53935),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(15),
                    //       ),
                    //       elevation: 2,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.appPrimaryRed,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  /// 🔹 Input Decoration
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

class TopText extends StatelessWidget {
  final String heading;

  const TopText({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: TextStyle(
        color: AppColors.appPrimaryRed,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
