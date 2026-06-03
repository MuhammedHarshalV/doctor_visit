import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';

import 'package:doctor_visit/model/profile/pro_profile_details_response_model.dart';

class GetProDetailsApi {
  static Future<dynamic> getProDetailsApi({required String proID}) async {
    try {
      final response = await GetApiServices.callApi(
        queryParams: {"ProId": proID},
        url: "${ApiConstants.baseUrl}${ApiConstants.proDetails}",
      );

      if (response == null) {
        return null;
      }

      return ProProfileDetailsResponseModel.fromJson(response);
    } catch (e) {
      log("get doctor visit error : $e");
      return null;
    }
  }
}
