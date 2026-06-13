import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';
import 'dart:developer';
import 'package:doctor_visit/model/work_completion_and_start_duty/is_going_response_model.dart';

class GetIsGoingApi {
  static Future<dynamic> getIsGoingApi({required String doctorID}) async {
    try {
      final response = await GetApiServices.callApi(
        queryParams: {"DrId": doctorID},
        url: "${ApiConstants.baseUrl}${ApiConstants.proIsGoing}",
      );

      if (response == null) {
        return null;
      }

      return IsGoingResponseModel.fromJson(response);
    } catch (e) {
      log("isGoing error : $e");
      return null;
    }
  }
}
