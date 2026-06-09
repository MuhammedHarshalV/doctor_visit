import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';

import 'package:doctor_visit/core/services/api_services/api_services.dart';
import 'package:doctor_visit/model/add_doctor_screen/areaOrSpeciality_fetch_response_model.dart';

class SpecialtyFetchApi {
  static Future<dynamic> specialtyFetchApi() async {
    try {
      final response = await GetApiServices.callApi(
        url: "${ApiConstants.baseUrl}${ApiConstants.specialityFetch}",
      );

      if (response == null) {
        return null;
      }

      return AreaOrSpecialityFetchResponseModel.fromJson(response);
    } catch (e) {
      log("speciality fetch api error : $e");
      return null;
    }
  }
}
