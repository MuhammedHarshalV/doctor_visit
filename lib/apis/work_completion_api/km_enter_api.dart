import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';

import 'package:doctor_visit/model/work_completion_and_start_duty/work_completion_and_start_duty_response_model.dart';

class KmEnterApi {
  static Future<dynamic> kmEnterApi({
    required String date,

    required num? startKm,
    required num? endKm,
    required String? startKmPhoto,
    required String? endKmPhoto,
  }) async {
    try {
      final FormData body = await createFormData(
        date: date,
        startKm: startKm,
        endKm: endKm,
        startKmPhoto: startKmPhoto,
        endKmPhoto: endKmPhoto,
      );
      final response = await PostApiServices.callApi(
        body: body,
        url: "${ApiConstants.baseUrl}${ApiConstants.workStartCompletevisit}",
      );

      if (response == null) {
        return null;
      }

      return WorkCompletionAndStartDutyResponseModel.fromJson(response);
    } catch (e) {
      log("post kelometer update error : $e");
      return null;
    }
  }

  static Future<FormData> createFormData({
    required String date,

    required num? startKm,
    required num? endKm,
    required String? startKmPhoto,
    required String? endKmPhoto,
  }) async {
    MultipartFile? startConverted;
    MultipartFile? endConverted;

    // 1. User selected new image from gallery/camera
    if (startKmPhoto != null) {
      startConverted = await MultipartFile.fromFile(
        startKmPhoto,
        filename: "start",
      );
    }
    if (endKmPhoto != null) {
      endConverted = await MultipartFile.fromFile(endKmPhoto, filename: "end");
    }

    final formData = FormData.fromMap({
      "ProMst_ProId": AppConstants.employeeID,
      "ProMst_Date": date,
      "ProMst_YrId": AppConstants.yearID,

      if (startKm != null) "ProMst_StartKM": startKm,

      if (endKm != null) "ProMst_EndKM": endKm,

      if (endKmPhoto != null && endKmPhoto.isNotEmpty)
        "ProMst_EndKMImg": endConverted,
      if (startKmPhoto != null && startKmPhoto.isNotEmpty)
        "ProMst_StartKMImg": startConverted,
    });

    return formData;
  }
}
