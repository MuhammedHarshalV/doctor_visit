import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doctor_visit/core/constants/api_constants.dart';

import 'package:doctor_visit/core/services/api_services/api_services.dart';


class HiTechCompletionApi {
  static Future<dynamic> hiTechCompletionApi({required FormData body}) async {
    try {
      final response = await PostApiServices.callApi(
        body: body,
        url: "${ApiConstants.baseUrl}${ApiConstants.hiTechCompletion}",
      );

      if (response == null) {
        return null;
      }

      return response["status"];
    } catch (e) {
      log("post work update error : $e");
      return null;
    }
  }
}
