import 'dart:developer';

import 'package:doctor_visit/apis/add_doctor/add_doctor_save_api.dart';
import 'package:doctor_visit/apis/add_doctor/area_fetch_api.dart';
import 'package:doctor_visit/apis/add_doctor/clinic_fetch_api.dart';
import 'package:doctor_visit/apis/add_doctor/specialty_fetch_api.dart';
import 'package:doctor_visit/controller/add_doctor_controller/add_doctor_state.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/model/add_doctor_screen/area_or_speciality_fetch_response_model.dart';
import 'package:doctor_visit/model/add_doctor_screen/clinic_fetch_response_model.dart';
import 'package:doctor_visit/view/screens/home_screen/widget/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDoctorsController extends StateNotifier<AddDoctorsState> {
  AddDoctorsController()
    : super(
        AddDoctorsState(
          formKey: GlobalKey<FormState>(),
          doctorNameController: TextEditingController(),
          doctorPhoneController: TextEditingController(),
          doctorSpecialityController: TextEditingController(),
          doctorClinicController: TextEditingController(),
          doctorDiscussionController: TextEditingController(),
          areaIdController: TextEditingController(),
          genderController: TextEditingController(),
        ),
      ) {
    iniatialCall();
  }
  @override
  void dispose() {
    log('add doctor controller disposed.');
    super.dispose();
  }

  Future<void> iniatialCall() async {
    await areaFetchApi();
    await specialityFetchApi();
    await clinicFetchApi();
  }

  Future<void> areaFetchApi() async {
    final AreaOrSpecialityFetchResponseModel? response =
        await AreaFetchApi.areaFetchApi();
    if (response != null && response.status == true) {
      state = state.copyWith(areaList: response.data ?? []);
      log('controller response : ${response.data}');
    } else {
      log('add doctor controller error');
    }
  }

  Future<void> specialityFetchApi() async {
    final AreaOrSpecialityFetchResponseModel? response =
        await SpecialtyFetchApi.specialtyFetchApi();
    if (response != null && response.status == true) {
      state = state.copyWith(specialityList: response.data ?? []);
      log('controller response : ${response.data}');
    } else {
      log('speciality controller error');
    }
  }

  Future<void> clinicFetchApi() async {
    final ClinicFetchResponseModel? response =
        await ClinicFetchApi.clinicFetchApi();
    if (response != null && response.status == true) {
      state = state.copyWith(clinicList: response.clinics ?? []);
      log('clinic controller response : ${response.clinics}');
    } else {
      log('clinic controller error');
    }
  }

  void updateStateClass({
    bool? isDropdownSpeciality,
    bool? isDropdownarea,
    bool? isDropdownClinic,
    bool? isSubmitted,
    String? isIncentive,
    int? areaId,
    int? specialityId,
    int? clinicId,
  }) {
    state = state.copyWith(
      isSubmitted: isSubmitted,
      isIncentive: isIncentive,
      areaId: areaId,
      specialityId: specialityId,
      clinicId: clinicId,
      isDropdownSpeciality: isDropdownSpeciality,
      isDropdownarea: isDropdownarea,
      isDropdownClinic: isDropdownClinic,
    );
  }

  //filtered area search list
  void filterArea(String query) {
    if (query.isEmpty) {
      state = state.copyWith(finalAreaList: state.areaList);
      return;
    }

    final filtered = state.areaList.where((e) {
      return (e.desc ?? '').toLowerCase().contains(query.toLowerCase());
    }).toList();

    state = state.copyWith(finalAreaList: filtered, isDropdownarea: true);
  }

  //filter specialty list
  void filterSpeciality(String query) {
    if (query.isEmpty) {
      state = state.copyWith(finalSpecialityList: state.specialityList);
      return;
    }

    final filtered = state.specialityList.where((e) {
      return (e.desc ?? '').toLowerCase().contains(query.toLowerCase());
    }).toList();

    state = state.copyWith(
      finalSpecialityList: filtered,
      isDropdownSpeciality: true,
    );
  }

  //filter clinic list
  void filterClinic(String query) {
    if (query.isEmpty) {
      state = state.copyWith(finalClinicList: state.clinicList);
      return;
    }

    final filtered = state.clinicList.where((e) {
      return (e.ahMstPName ?? '').toLowerCase().contains(query.toLowerCase());
    }).toList();

    state = state.copyWith(finalClinicList: filtered, isDropdownClinic: true);
  }

  void clearFilteredAreaList() {
    state = state.copyWith(finalAreaList: []);
  }

  void clearFilteredspecialityList() {
    state = state.copyWith(finalSpecialityList: []);
  }

  void clearFilteredClinicList() {
    state = state.copyWith(finalClinicList: []);
  }

  //add doctor saving
  Future<void> addDoctorSave({
    required BuildContext context,
    required String doctocName,
    required String doctorPhone,
    required int specialId,
    required String specialityName,
    required int clinicId,
    required String clinicName,
    required String discription,
    required bool isIncentive,
    required int areaId,
    required String areaName,
    required String proGender,
  }) async {
    state = state.copyWith(isSubmitted: true);
    try {
      final String? response = await AddDoctorSaveApi.addDoctorSaveApi(
        proId: int.parse(AppConstants.employeeID),
        doctocName: doctocName,
        doctorPhone: doctorPhone,
        specialId: specialId,
        specialityName: specialityName,
        clinicId: clinicId,
        clinicName: clinicName,
        discription: discription,
        isIncentive: isIncentive,
        areaId: areaId,
        areaName: areaName,
        proGender: proGender,
      );
      log(response.toString());
      if (response != null && response.isNotEmpty) {
        state.doctorNameController.clear();
        state.doctorPhoneController.clear();
        state.doctorSpecialityController.clear();
        state.doctorClinicController.clear();
        state.doctorDiscussionController.clear();
        state.areaIdController.clear();
        state = state.copyWith(
          areaId: 0,
          specialityId: 0,
          isIncentive: 'No',
          clinicId: 0,
        );
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return CommonAlertDialog(
              message:
                  'The new doctor registration request has been submitted successfully and is awaiting for approval.',
            );
          },
        );
      } else {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return CommonAlertDialog(
              message:
                  'The new doctor registration request has been Failed./n Retry',
            );
          },
        );
      }
    } catch (e) {
      log(e.toString());
    } finally {
      state = state.copyWith(isSubmitted: false);
    }
  }
}

final addDoctorProvider =
    StateNotifierProvider<AddDoctorsController, AddDoctorsState>(
      (ref) => AddDoctorsController(),
    );
