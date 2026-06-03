import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';

import 'package:doctor_visit/model/work_completion_and_start_duty/work_completion_and_start_duty_response_model.dart';

class PostWorkStartApi {
  static Future<dynamic> postWorkStartApi({
    required String date,
    required String? startTime,
    required String? endTime,

    required String? startLocation,
    required String? endLocation,
  }) async {
    try {
      final Map<String, dynamic> proDet = {};

      if (startLocation != null) {
        proDet["ProDet_StartLoc"] = startLocation;
      }

      if (endLocation != null) {
        proDet["ProDet_EndLoc"] = endLocation;
      }

      if (startTime != null) {
        proDet["ProDet_StartTime"] = startTime;
      }

      if (endTime != null) {
        proDet["ProDet_EndTime"] = endTime;
      }

      final response = await PostApiServices.callApi(
        body: {
          "ProMst_ProId": AppConstants.employeeID,
          "ProMst_Date": date,
          "ProMst_YrId": AppConstants.yearID,

          "proDet": [proDet],
        },
        url: "${ApiConstants.baseUrl}${ApiConstants.workStartCompletevisit}",
      );

      if (response == null) {
        return null;
      }

      return WorkCompletionAndStartDutyResponseModel.fromJson(response);
    } catch (e) {
      log("post work update error : $e");
      return null;
    }
  }
}
