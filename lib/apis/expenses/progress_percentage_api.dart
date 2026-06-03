import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';

import 'package:doctor_visit/model/progress_percentage/progress_percentage_response_model.dart';

class GetProgressPercentage {
  static Future<dynamic> getProgressPercentage() async {
    try {
      final response = await GetApiServices.callApi(
        queryParams: {"EmpId": AppConstants.employeeID},
        url: "${ApiConstants.baseUrl}${ApiConstants.progressPercentage}",
      );

      if (response == null) {
        return null;
      }

      return ProgressPercentageResponseModel.fromJson(response);
    } catch (e) {
      log("progress percentage error : $e");
      return null;
    }
  }
}
