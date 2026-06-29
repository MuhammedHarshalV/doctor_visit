import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';

import 'package:doctor_visit/core/services/api_services/api_services.dart';

class DeleteAssignedDoctorApi {
  static Future<dynamic> deleteAssignedDoctorApi({
    required String date,
    required String drId,
  }) async {
    try {
      final response = await PostApiServices.callApi(
        body: {
          "ProDrList_DrId": drId,
          "ProDrList_AssignedOn": date,
          "logUser": AppConstants.userName,
          "UsrId": AppConstants.employeeID,
        },
        url: "${ApiConstants.baseUrl}${ApiConstants.deleteAssignedDoctor}",
      );

      if (response == null) {
        return null;
      }

      return response['status'];
    } catch (e) {
      log("delete assigned doctor error : $e");
      return null;
    }
  }
}
