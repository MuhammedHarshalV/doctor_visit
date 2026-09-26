import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';

import 'package:doctor_visit/core/services/api_services/api_services.dart';

class GetKilometerApi {
  static Future<dynamic> getKilometerApi() async {
    try {
      final response = await GetApiServices.callApi(
        url:
            "${ApiConstants.baseUrl}${ApiConstants.getKilometer}${AppConstants.employeeID}",
      );

      if (response == null) {
        return null;
      }

      return response;
    } catch (e) {
      log("get kilometer error : $e");
      return null;
    }
  }
}
