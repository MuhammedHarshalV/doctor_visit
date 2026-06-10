import 'dart:developer';

import 'package:doctor_visit/controller/add_doctor_controller/add_doctor_controller.dart';
import 'package:doctor_visit/controller/bottom_nav_screen/bottom_nav_controller.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';

import 'package:doctor_visit/view/widgets/common_appbar.dart';
import 'package:doctor_visit/view/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDoctorScreen extends ConsumerWidget {
  const AddDoctorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addDoctorScreenWatch = ref.watch(addDoctorProvider);
    final addDoctorScreenRead = ref.read(addDoctorProvider.notifier);

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
              key: addDoctorScreenWatch.formKey,
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
                      validationType: ValidationType.name,
                      hintText: 'Doctor Name',
                      textController: addDoctorScreenWatch.doctorNameController,
                      preIcon: Icon(
                        Icons.person_2_outlined,
                        color: AppColors.appPrimaryRed,
                      ),
                    ),
                    SizedBox(height: 5),

                    TopText(heading: 'Phone Number *'),
                    SizedBox(height: 7),
                    TypeTextFormField(
                      validationType: ValidationType.phone,
                      hintText: 'Phone Number',
                      textController:
                          addDoctorScreenWatch.doctorPhoneController,
                      preIcon: Icon(
                        Icons.phone,
                        color: AppColors.appPrimaryRed,
                      ),
                      isNumber: true,
                    ),
                    SizedBox(height: 5),

                    TopText(heading: 'Speciality *'),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Expanded(
                          child: TypeTextFormField(
                            validationType: ValidationType.name,
                            hintText: 'Speciality',
                            textController:
                                addDoctorScreenWatch.doctorSpecialityController,
                            preIcon: Icon(
                              Icons.medical_information_outlined,
                              color: AppColors.appPrimaryRed,
                            ),
                            onChanged: (p0) {
                              final item = addDoctorScreenWatch.specialityList
                                  .cast()
                                  .where(
                                    (e) =>
                                        (e.desc ?? '').trim().toLowerCase() ==
                                        p0.trim().toLowerCase(),
                                  );

                              if (item.isNotEmpty) {
                                addDoctorScreenRead.updateStateClass(
                                  specialityId: item.first.key,
                                );

                                log('speciality id assign ${item.first.key}');
                              } else {
                                addDoctorScreenRead.updateStateClass(
                                  specialityId: 0,
                                );

                                log('speciality id assign 0');
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTapDown: (details) {
                            showMore(
                              context: context,
                              tapPosition: details.globalPosition,
                              items: addDoctorScreenWatch.specialityList,
                              onSelected: (key, desc) {
                                addDoctorScreenWatch
                                        .doctorSpecialityController
                                        .text =
                                    desc;

                                addDoctorScreenRead.updateStateClass(
                                  specialityId: key,
                                );
                              },
                            ); // directly pass it
                          },
                          child: Container(
                            height: 60, // same height as TextField
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFFEBEE,
                              ), // light red background
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(children: [Icon(Icons.arrow_drop_down)]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),

                    TopText(heading: 'Area *'),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Expanded(
                          child: TypeTextFormField(
                            validationType: ValidationType.name,
                            onChanged: (p0) {
                              final item = addDoctorScreenWatch.areaList
                                  .cast()
                                  .where(
                                    (e) =>
                                        (e.desc ?? '').trim().toLowerCase() ==
                                        p0.trim().toLowerCase(),
                                  );

                              if (item.isNotEmpty) {
                                addDoctorScreenRead.updateStateClass(
                                  areaId: item.first.key,
                                );

                                log('area id id assign ${item.first.key}');
                              } else {
                                addDoctorScreenRead.updateStateClass(
                                  specialityId: 0,
                                );

                                log('area id id assign 0');
                              }
                            },
                            hintText: addDoctorScreenWatch.areaId == 0
                                ? 'Area'
                                : '',
                            textController:
                                addDoctorScreenWatch.areaIdController,
                            preIcon: Icon(
                              Icons.area_chart_outlined,
                              color: AppColors.appPrimaryRed,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTapDown: (details) {
                            showMore(
                              context: context,
                              tapPosition: details.globalPosition,
                              items: addDoctorScreenWatch.areaList,
                              onSelected: (key, desc) {
                                addDoctorScreenWatch.areaIdController.text =
                                    desc;
                                addDoctorScreenRead.updateStateClass(
                                  areaId: key,
                                );
                              },
                            ); // directly pass it
                          },
                          child: Container(
                            height: 60, // same height as TextField
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFFEBEE,
                              ), // light red background
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(children: [Icon(Icons.arrow_drop_down)]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),

                    TopText(heading: 'Clinic Name *'),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Expanded(
                          child: TypeTextFormField(
                            onChanged: (p0) {
                              final item = addDoctorScreenWatch.clinicList
                                  .cast()
                                  .where(
                                    (e) =>
                                        (e.ahMstPName ?? '')
                                            .trim()
                                            .toLowerCase() ==
                                        p0.trim().toLowerCase(),
                                  );

                              if (item.isNotEmpty) {
                                addDoctorScreenRead.updateStateClass(
                                  clinicId: item.first.ahMstKey,
                                );

                                log(
                                  'clinic id id assign ${item.first.ahMstKey}',
                                );
                              } else {
                                addDoctorScreenRead.updateStateClass(
                                  clinicId: 0,
                                );

                                log('clinic id id assign 0');
                              }
                            },
                            validationType: ValidationType.name,
                            hintText: 'Clinic Name',
                            textController:
                                addDoctorScreenWatch.doctorClinicController,

                            preIcon: Icon(
                              Icons.medical_services_outlined,
                              color: AppColors.appPrimaryRed,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTapDown: (details) {
                            showMore(
                              isClinic: true,
                              context: context,
                              tapPosition: details.globalPosition,
                              items: addDoctorScreenWatch.clinicList,
                              onSelected: (ahMstKey, ahMstPName) {
                                addDoctorScreenWatch
                                        .doctorClinicController
                                        .text =
                                    ahMstPName;
                                addDoctorScreenRead.updateStateClass(
                                  clinicId: ahMstKey,
                                );
                              },
                            ); // directly pass it
                          },
                          child: Container(
                            height: 60, // same height as TextField
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFFEBEE,
                              ), // light red background
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(children: [Icon(Icons.arrow_drop_down)]),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    TopText(heading: 'Incentive'),
                    SizedBox(height: 7),
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: addDoctorScreenWatch.isIncentive,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFFFEBEE),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          dropdownColor: Colors.white, // dropdown background

                          borderRadius: BorderRadius.circular(
                            15,
                          ), // popup border radius
                          // Always display this text
                          selectedItemBuilder: (context) {
                            return ['Yes', 'No'].map((e) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  addDoctorScreenWatch.isIncentive,
                                  style: TextStyle(
                                    color: AppColors.appBlack,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList();
                          },

                          items: const [
                            DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                            DropdownMenuItem(value: 'No', child: Text('No')),
                          ],

                          onChanged: (value) {
                            addDoctorScreenRead.updateStateClass(
                              isIncentive: value,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 5),

                    _sectionTitle("Discussion"),
                    TextFormField(
                      controller:
                          addDoctorScreenWatch.doctorDiscussionController,
                      maxLines: 4,
                      maxLength: 1000,
                      decoration: _inputDecoration(""),
                      onTapOutside: (_) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
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
                              if (addDoctorScreenWatch.formKey.currentState!
                                  .validate()) {
                                await addDoctorScreenRead.addDoctorSave(
                                  context: context,
                                  doctocName: addDoctorScreenWatch
                                      .doctorNameController
                                      .text,
                                  doctorPhone: addDoctorScreenWatch
                                      .doctorPhoneController
                                      .text,
                                  specialId: addDoctorScreenWatch.specialityId,
                                  specialityName: addDoctorScreenWatch
                                      .doctorSpecialityController
                                      .text,
                                  clinicId: addDoctorScreenWatch.clinicId,
                                  clinicName: addDoctorScreenWatch
                                      .doctorClinicController
                                      .text,
                                  discription: addDoctorScreenWatch
                                      .doctorDiscussionController
                                      .text,
                                  isIncentive:
                                      addDoctorScreenWatch.isIncentive == 'No'
                                      ? false
                                      : true,
                                  areaId: addDoctorScreenWatch.areaId,
                                );

                                log(
                                  "Add doctor Details :name =${addDoctorScreenWatch.doctorNameController.text}, phone =${addDoctorScreenWatch.doctorPhoneController.text},speciality =${addDoctorScreenWatch.doctorSpecialityController.text},clinic name =${addDoctorScreenWatch.doctorClinicController.text} ",
                                );

                                bottomNavNotifier.setIndex(0);
                              } else {
                                log("Show errors ");
                              }
                            },

                            label: addDoctorScreenWatch.isSubmitted == true
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.appWhite,
                                      ),
                                    ),
                                  )
                                : Text(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showMore({
    bool? isClinic = false,
    required BuildContext context,
    required Offset tapPosition,
    required List<dynamic> items,
    required Function(int key, String desc) onSelected,
  }) async {
    final selected = await showMenu<int>(
      color: Colors.white,
      context: context,
      position: RelativeRect.fromLTRB(tapPosition.dx, tapPosition.dy, 0, 0),
      items: items.map((item) {
        return PopupMenuItem<int>(
          value: isClinic == true ? item.ahMstKey : item.key,
          child: isClinic == true
              ? Text(item.ahMstPName ?? '')
              : Text(item.desc ?? ''),
        );
      }).toList(),
    );

    if (selected != null) {
      if (isClinic == true) {
        final selectedItem = items.firstWhere((e) => e.ahMstKey == selected);

        onSelected(selectedItem.ahMstKey ?? 0, selectedItem.ahMstPName ?? '');

        log('Selected Key: ${selectedItem.ahMstKey}');
        log('Selected Desc: ${selectedItem.ahMstPName}');
      } else {
        final selectedItem = items.firstWhere((e) => e.key == selected);

        onSelected(selectedItem.key ?? 0, selectedItem.desc ?? '');

        log('Selected Key: ${selectedItem.key}');
        log('Selected Desc: ${selectedItem.desc}');
      }
    }
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
