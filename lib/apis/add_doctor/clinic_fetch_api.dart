import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';

import 'package:doctor_visit/core/services/api_services/api_services.dart';
import 'package:doctor_visit/model/add_doctor_screen/clinic_fetch_response_model.dart';

class ClinicFetchApi {
  static Future<dynamic> clinicFetchApi() async {
    try {
      final response = await GetApiServices.callApi(
        url: "${ApiConstants.baseUrl}${ApiConstants.clinicSearch}",
      );

      if (response == null) {
        return null;
      }

      return ClinicFetchResponseModel.fromJson(response);
    } catch (e) {
      log("area fetch api error : $e");
      return null;
    }
  }
}
