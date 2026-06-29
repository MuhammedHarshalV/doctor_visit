import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';
import 'package:doctor_visit/model/doctos_assign_get/weekly_assign_history_response_model.dart';

class WeeklyAssignedDoctorHistoryApi {
  static Future<dynamic> weeklyAssignedDoctorHistory() async {
    try {
      final response = await GetApiServices.callApi(
        queryParams: {"ProId": AppConstants.employeeID},
        url:
            "${ApiConstants.baseUrl}${ApiConstants.weeklyAssignedDoctorHistory}",
      );

      if (response == null) {
        return null;
      }

      return WeeklyAssignedDoctorResponseModel.fromJson(response);
    } catch (e) {
      log("weekly assigned doctor result error : $e");
      return null;
    }
  }
}
