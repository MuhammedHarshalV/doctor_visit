import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';

import 'package:doctor_visit/model/work_completion_and_start_duty/work_completion_and_start_duty_response_model.dart';

class PostWorkStartGoingApi {
  static Future<dynamic> postWorkStartGoingApi({
    required String date,
    required String? startTime,
    required String? endTime,

    required String doctorID,
    required String? feedback,
    required String? workstatus,
    required String? base64Image,

    required String? startLocation,
    required String? endLocation,
  }) async {
    try {
      final Map<String, dynamic> proDet = {};

      if (workstatus != null) {
        proDet["ProDet_Status"] = workstatus;
      }
      if (feedback != null) {
        proDet["ProDet_Feedback"] = feedback;
      }

      proDet["ProDet_DrId"] = doctorID;

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
      if (base64Image != null) {
        proDet["ProDet_ImgBase64"] = base64Image;
      }

      final response = await PostApiServices.callApi(
        body: {
          "IsUpdate": true,

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
