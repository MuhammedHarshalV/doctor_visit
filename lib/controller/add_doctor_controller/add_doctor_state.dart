import 'package:doctor_visit/model/add_doctor_screen/areaOrSpeciality_fetch_response_model.dart';
import 'package:doctor_visit/model/add_doctor_screen/clinic_fetch_response_model.dart';
import 'package:flutter/material.dart';

class AddDoctorsState {
  final GlobalKey<FormState> formKey;
  final int areaId;
  final int specialityId;
  final int clinicId;
  final bool isSubmitted;
  final String isIncentive;
  final TextEditingController doctorNameController;
  final TextEditingController doctorPhoneController;
  final TextEditingController doctorSpecialityController;
  final TextEditingController doctorClinicController;
  final TextEditingController doctorDiscussionController;
  final TextEditingController areaIdController;
  final List<Datum> areaList;
  final List<Datum> specialityList;
  final List<Clinic> clinicList;

  AddDoctorsState({
    required this.formKey,
    this.areaId = 0,
    this.specialityId = 0,
    this.clinicId = 0,
    this.areaList = const [],
    this.specialityList = const [],
    this.clinicList = const [],

    this.isIncentive = 'No',
    this.isSubmitted = false,
    required this.doctorNameController,
    required this.doctorPhoneController,
    required this.doctorSpecialityController,
    required this.doctorClinicController,
    required this.doctorDiscussionController,
    required this.areaIdController,
  });

  AddDoctorsState copyWith({
    GlobalKey<FormState>? formKey,
    int? clinicId,
    int? areaId,
    int? specialityId,
    bool? isSubmitted,
    List<Datum>? areaList,
    List<Datum>? specialityList,
    List<Clinic>? clinicList,

    TextEditingController? doctorNameController,
    TextEditingController? doctorPhoneController,
    TextEditingController? doctorSpecialityController,
    TextEditingController? doctorClinicController,
    TextEditingController? doctorDiscussionController,
    TextEditingController? areaIdController,
    String? isIncentive,
  }) {
    return AddDoctorsState(
      areaIdController: areaIdController ?? this.areaIdController,
      isIncentive: isIncentive ?? this.isIncentive,
      clinicId: clinicId ?? this.clinicId,
      specialityList: specialityList ?? this.specialityList,
      specialityId: specialityId ?? this.specialityId,
      areaId: areaId ?? this.areaId,
      formKey: formKey ?? this.formKey,
      areaList: areaList ?? this.areaList,
      clinicList: clinicList ?? this.clinicList,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      doctorNameController: doctorNameController ?? this.doctorNameController,
      doctorPhoneController:
          doctorPhoneController ?? this.doctorPhoneController,
      doctorSpecialityController:
          doctorSpecialityController ?? this.doctorSpecialityController,
      doctorClinicController:
          doctorClinicController ?? this.doctorClinicController,
      doctorDiscussionController:
          doctorDiscussionController ?? this.doctorDiscussionController,
    );
  }
}
