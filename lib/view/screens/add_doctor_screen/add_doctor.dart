import 'dart:developer';

import 'package:doctor_visit/controller/add_doctor_controller/add_doctor_controller.dart';
import 'package:doctor_visit/controller/bottom_nav_screen/bottom_nav_controller.dart';
import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
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
                    Text(
                      "Add Doctor",
                      style: AppTextStyles.anekMalayalam(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Quickly register a doctor for today's visits",
                      style: AppTextStyles.anekMalayalam(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
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
                              addDoctorScreenRead.updateStateClass(
                                isDropdownarea: false,
                                isDropdownClinic: false,
                              );
                              addDoctorScreenRead.filterSpeciality(p0);
                              final item = addDoctorScreenWatch.specialityList
                                  .cast()
                                  .where(
                                    (e) =>
                                        (e.desc ?? '').trim().toLowerCase() ==
                                        p0.trim().toLowerCase(),
                                  );
                              if (p0.isEmpty) {
                                addDoctorScreenRead
                                    .clearFilteredspecialityList();
                              }
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
                      ],
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(addDoctorProvider);
                        final controller = ref.read(addDoctorProvider.notifier);
                        if (state.isDropdownSpeciality == false ||
                            state.finalSpecialityList.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          color: AppColors.appGrey,
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.finalSpecialityList.length,
                            itemBuilder: (context, index) {
                              final item = state.finalSpecialityList[index];

                              return ListTile(
                                title: Text(
                                  item.desc ?? '',
                                  style: AppTextStyles.anekMalayalam(),
                                ),
                                onTap: () {
                                  log(
                                    "Before: ${state.doctorSpecialityController.text}",
                                  );

                                  state.doctorSpecialityController.text =
                                      item.desc ?? '';
                                  Future.microtask(() {
                                    log(
                                      'Updated speciality id : ${ref.read(addDoctorProvider).specialityId}',
                                    );
                                  });
                                  log(
                                    "After: ${state.doctorSpecialityController.text}",
                                  );
                                  controller.updateStateClass(
                                    specialityId: item.key,
                                    isDropdownSpeciality: false,
                                  );
                                  controller.clearFilteredspecialityList();
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 5),

                    TopText(heading: 'Area *'),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Expanded(
                          child: TypeTextFormField(
                            validationType: ValidationType.name,
                            textController:
                                addDoctorScreenWatch.areaIdController,
                            onChanged: (p0) {
                              addDoctorScreenRead.updateStateClass(
                                isDropdownSpeciality: false,
                                isDropdownClinic: false,
                              );
                              addDoctorScreenRead.filterArea(p0);
                              String normalize() {
                                return p0.trim().toLowerCase().replaceAll(
                                  RegExp(r'\s+'),
                                  ' ',
                                );
                              }

                              final item = addDoctorScreenWatch.areaList
                                  .cast()
                                  .where(
                                    (e) =>
                                        (e.desc ?? '').trim().toLowerCase() ==
                                        normalize(),
                                  );
                              if (p0.isEmpty) {
                                addDoctorScreenRead.clearFilteredAreaList();
                              }
                              if (item.isNotEmpty) {
                                addDoctorScreenRead.updateStateClass(
                                  areaId: item.first.key,
                                );

                                log('area id id assign ${item.first.key}');
                              } else {
                                addDoctorScreenRead.updateStateClass(areaId: 0);

                                log('area id id assign 0');
                              }
                            },
                            hintText: addDoctorScreenWatch.areaId == 0
                                ? 'Area'
                                : '',

                            preIcon: Icon(
                              Icons.area_chart_outlined,
                              color: AppColors.appPrimaryRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(addDoctorProvider);
                        final controller = ref.read(addDoctorProvider.notifier);
                        if (state.isDropdownarea == false ||
                            state.finalAreaList.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          color: AppColors.appGrey,
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.finalAreaList.length,
                            itemBuilder: (context, index) {
                              final item = state.finalAreaList[index];

                              return ListTile(
                                title: Text(
                                  item.desc ?? '',
                                  style: AppTextStyles.anekMalayalam(),
                                ),
                                onTap: () {
                                  state.areaIdController.text = item.desc ?? '';

                                  controller.updateStateClass(areaId: item.key);

                                  log('Selected area id 5: ${item.key}');
                                  Future.microtask(() {
                                    log(
                                      'Updated area id 6: ${ref.read(addDoctorProvider).areaId}',
                                    );
                                  });
                                  log('assign area id 4 :${state.areaId}');
                                  controller.clearFilteredAreaList();
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 5),

                    TopText(heading: 'Clinic Name *'),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Expanded(
                          child: TypeTextFormField(
                            onChanged: (p0) {
                              addDoctorScreenRead.updateStateClass(
                                isDropdownSpeciality: false,
                                isDropdownarea: false,
                              );
                              addDoctorScreenRead.filterClinic(p0);
                              final item = addDoctorScreenWatch.clinicList
                                  .cast()
                                  .where(
                                    (e) =>
                                        (e.ahMstPName ?? '')
                                            .trim()
                                            .toLowerCase() ==
                                        p0.trim().toLowerCase(),
                                  );
                              if (p0.isEmpty) {
                                addDoctorScreenRead.clearFilteredClinicList();
                              }
                              if (item.isNotEmpty) {
                                addDoctorScreenRead.updateStateClass(
                                  clinicId: item.first.ahMstPName.isNotEmpty
                                      ? item.first.ahMstKey
                                      : 0,
                                );

                                log(
                                  'clinic id assign 1 :${addDoctorScreenWatch.clinicId}',
                                );
                              } else {
                                addDoctorScreenRead.updateStateClass(
                                  clinicId: 0,
                                );
                                //  addDoctorScreenRead.clearFilteredClinicList();

                                log(
                                  'clinic id assign 2 :${addDoctorScreenWatch.clinicId}',
                                );
                              }
                              log(
                                'clinic id assign 3 :${addDoctorScreenWatch.clinicId}',
                              );
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
                      ],
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(addDoctorProvider);
                        final controller = ref.read(addDoctorProvider.notifier);

                        if (state.finalClinicList.isEmpty ||
                            state.isDropdownClinic == false) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          color: AppColors.appGrey,
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.finalClinicList.length,
                            itemBuilder: (context, index) {
                              final item = state.finalClinicList[index];

                              return ListTile(
                                title: Text(
                                  item.ahMstPName ?? '',
                                  style: AppTextStyles.anekMalayalam(),
                                ),
                                onTap: () {
                                  state.doctorClinicController.text =
                                      item.ahMstPName ?? '';

                                  controller.updateStateClass(
                                    clinicId: item.ahMstKey,
                                  );
                                  log('Selected clinic id 5: ${item.ahMstKey}');
                                  Future.microtask(() {
                                    log(
                                      'Updated clinic id 6: ${ref.read(addDoctorProvider).clinicId}',
                                    );
                                  });
                                  log('assign clinic id 4 :${state.clinicId}');
                                  controller.clearFilteredClinicList();
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),

                    _sectionTitle("Incentive"),
                    SizedBox(height: 5),
                    TypeTextFormField(
                      isIncentive: true,
                      hintText: addDoctorScreenWatch.isIncentive,
                      textController: TextEditingController(
                        text: addDoctorScreenWatch.isIncentive,
                      ),
                      isSuffix: true,
                      isReadOnly: true,
                      onChanged: (p0) {
                        addDoctorScreenRead.updateStateClass(isIncentive: p0);
                      },
                      preIcon: Icon(
                        Icons.card_giftcard,
                        color: AppColors.appPrimaryRed,
                      ),
                    ),
                    SizedBox(height: 5),
                    _sectionTitle("Gender *"),
                    SizedBox(height: 5),
                    TypeTextFormField(
                      hintText: 'Gender',
                      textController: addDoctorScreenWatch.genderController,
                      isSuffix: true,
                      isReadOnly: true,
                      onChanged: (p0) {
                        addDoctorScreenWatch.genderController.text = p0;
                      },
                      preIcon: Icon(Icons.wc, color: AppColors.appPrimaryRed),
                    ),
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
                                  areaName: addDoctorScreenWatch
                                      .areaIdController
                                      .text,
                                  proGender: addDoctorScreenWatch
                                      .genderController
                                      .text,
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
                                    style: AppTextStyles.anekMalayalam(
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
              ? Text(
                  item.ahMstPName ?? '',
                  style: AppTextStyles.anekMalayalam(),
                )
              : Text(item.desc ?? '', style: AppTextStyles.anekMalayalam()),
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
          style: AppTextStyles.anekMalayalam(
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
      style: AppTextStyles.anekMalayalam(
        color: AppColors.appPrimaryRed,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
