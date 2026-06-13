import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';

import 'package:doctor_visit/core/services/api_services/api_services.dart';

class AddDoctorSaveApi {
  static Future<dynamic> addDoctorSaveApi({
    required String? doctocName,
    required String? doctorPhone,
    required int? specialId,
    required String? specialityName,
    required int? clinicId,
    required String? clinicName,
    required String? areaName,
    required String? discription,
    required bool? isIncentive,
    required int? areaId,
    required int? proId,
    required String? proGender
  }) async {
    try {
      final Map<String, dynamic> body = {};
      if (doctocName != null) {
        body["TempDr_Name"] = doctocName;
      }
      if (doctorPhone != null) {
        body["TempDr_Mobile"] = doctorPhone;
      }
      if (specialId != null) {
        body["TempDr_SplId"] = specialId;
      }

      if (specialityName != null) {
        body["TempDr_Spec"] = specialityName;
      }
      if (clinicId != null) {
        body["TempDr_ClinicId"] = clinicId;
      }
      if (clinicName != null) {
        body["TempDr_ClinicName"] = clinicName;
      }

      if (discription != null) {
        body["TempDr_Note"] = discription;
      }
      if (isIncentive != null) {
        body["TempDr_isIncentive"] = isIncentive;
      }
      if (areaId != null) {
        body["TempDr_AreaId"] = areaId;
      }
      if (areaName != null) {
        body["TempDr_AreaName"] = areaName;
      }
      if (proId != null) {
        body["TempDr_ProId"] = proId;
      }if (proGender != null) {
        body["TempDr_Gender"] = proGender;
      }

      final response = await PostApiServices.callApi(
        body: body,
        url: "${ApiConstants.baseUrl}${ApiConstants.tempDoctorSave}",
      );

      if (response == null) {
        return null;
      }

      return response['message'];
    } catch (e) {
      log("add doctor save error : $e");
      return null;
    }
  }
}
