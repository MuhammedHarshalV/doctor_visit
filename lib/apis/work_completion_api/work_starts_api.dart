import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';

import 'package:doctor_visit/model/work_completion_and_start_duty/work_completion_and_start_duty_response_model.dart';
import 'package:flutter/material.dart';

class PostWorkStartApi {
  static Future<dynamic> postWorkStartApi({
    required String date,
    required String? startTime,
    required String? endTime,
    required BuildContext? context,
    required String? startLocation,
    required String? endLocation,
  }) async {
    try {
      final FormData body = await createFormData(
        date: date,
        startTime: startTime,
        endTime: endTime,

        startLocation: startLocation,
        endLocation: endLocation,
      );

      final response = await PostApiServices.callApi(
        body: body,
        url: "${ApiConstants.baseUrl}${ApiConstants.workStartCompletevisit}",
        context: context,
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

  static Future<FormData> createFormData({
    required String date,
    required String? startTime,
    required String? endTime,

    required String? startLocation,
    required String? endLocation,
  }) async {
    final formData = FormData.fromMap({
      "ProMst_ProId": AppConstants.employeeID,
      "ProMst_Date": date,
      "ProMst_YrId": AppConstants.yearID,

      if (startLocation != null) "ProDet_StartLoc": startLocation,

      if (endLocation != null) "ProDet_EndLoc": endLocation,

      if (startTime != null) "ProDet_StartTime": startTime,

      if (endTime != null) "ProDet_EndTime": endTime,
    });

    return formData;
  }
}
