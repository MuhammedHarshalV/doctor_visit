import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';

import 'package:doctor_visit/model/work_completion_and_start_duty/work_completion_and_start_duty_response_model.dart';

class KmEnterApi {
  static Future<dynamic> kmEnterApi({
    required String date,

    required num? startKm,
    required num? endKm,
  }) async {
    try {
      final response = await PostApiServices.callApi(
        body: {
          "ProMst_ProId": AppConstants.employeeID,
          "ProMst_Date": date,
          "ProMst_YrId": AppConstants.yearID,

          "ProMst_StartKM": startKm,

          "ProMst_EndKM": endKm,
          "proDet": [{}],
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
