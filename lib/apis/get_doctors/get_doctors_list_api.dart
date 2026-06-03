import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';
import 'package:doctor_visit/model/doctos_assign_get/doctors_assign_response_model.dart';



class GetDoctorsListApi {
  static Future<dynamic> getDoctorsListApi({required String proID}) async {
    try {
      final response = await GetApiServices.callApi(
        queryParams: {"ProId": proID},
        url: "${ApiConstants.baseUrl}${ApiConstants.getDoctorsVisit}",
      );

      if (response == null) {
        return null;
      }

      return DoctorsAssignResponseModel.fromJson(response);
    } catch (e) {
      log("get doctor visit error : $e");
      return null;
    }
  }
}
