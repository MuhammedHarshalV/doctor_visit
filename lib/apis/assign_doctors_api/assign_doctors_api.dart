import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';

class AssignDoctorsApi {
  static Future<dynamic> assignDoctorsApi({
    required String? date,
    required List<int>? doctorIDs,
  }) async {
    try {
      final response = await PostApiServices.callApi(
        body: {
          "ProDrList_ProId": AppConstants.employeeID,
          "ProDrList_AssignedOn": date,
          "DoctorIds": doctorIDs,
        },
        url: "${ApiConstants.baseUrl}${ApiConstants.assignDoctors}",
      );

      if (response == null) {
        return null;
      }

      return (response['status']);
    } catch (e) {
      log("post assign doctors error : $e");
      return null;
    }
  }
}
