import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doctor_visit/core/api_errors/api_errors.dart';
import 'package:flutter/material.dart';

//Dio get Api

class GetApiServices {
  static final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  static Future<dynamic> callApi({
    required BuildContext context,
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      log("=========== API REQUEST ===========");
      log("METHOD : POST");
      log("URL    : $url");
      log("BODY   : ${body ?? {}}");
      log("QUERY  : ${queryParams ?? {}}");
      log("===================================");

      final response = await dio.get(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: {"Authorization": token != null ? "Bearer $token" : null},
        ),
      );

      log("=========== API RESPONSE ===========");
      log("STATUS CODE : ${response.statusCode}");
      log("DATA : ${response.data}");
      log("===================================");

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        AppMessage.show(context, "Server Error : ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      log("DIO ERROR : ${e.message}");

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        AppMessage.show(context, "Connection timed out");
      } else if (e.type == DioExceptionType.connectionError) {
        AppMessage.show(context, "No Internet Connection");
      } else if (e.response != null) {
        AppMessage.show(context, "Server Error : ${e.response?.statusCode}");
      } else {
        AppMessage.show(context, e.message ?? "Unknown Error");
      }

      return null;
    } catch (e) {
      log("UNKNOWN ERROR : $e");
      AppMessage.show(context, e.toString());
      return null;
    }
  }
}
