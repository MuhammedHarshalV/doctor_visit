//
import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';
import 'package:doctor_visit/model/doctos_assign_get/assigned_doctors_by_area_response_model.dart';

class GetDoctorsAreaid {
  static Future<dynamic> getDoctorsAreaid({
    required String areaID,
    required String date,
  }) async {
    try {
      final response = await GetApiServices.callApi(
        queryParams: {"AreaId": areaID, "date": date},
        url: "${ApiConstants.baseUrl}${ApiConstants.getAssignedDoctorArea}",
      );

      if (response == null) {
        return null;
      }

      return AssignedDoctorByAreaResponseModel.fromJson(response);
    } catch (e) {
      log("get assigned doctor by area error : $e");
      return null;
    }
  }
}
