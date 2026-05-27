import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';
import 'package:doctor_visit/model/login/login_response_model.dart';

import 'package:flutter/material.dart';

class LoginApiService {
  static Future<dynamic> loginApiService({
    required String pin,
    required BuildContext context,
  }) async {
    try {
      final response = await GetApiServices.callApi(
        context: context,
        queryParams: {"pin": pin},
        url: "${ApiConstants.baseUrl}${ApiConstants.login}",
      );

      if (response == null) {
        return null;
      }

      return LoginResponseModel.fromJson(response);
    } catch (e) {
      log("Login error : $e");
      return null;
    }
  }
}
