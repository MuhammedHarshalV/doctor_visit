import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:doctor_visit/core/api_errors/api_errors.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

//Dio get Api

class GetApiServices {
  static final Dio dio =
      Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
          ),
        )
        ..httpClientAdapter = IOHttpClientAdapter(
          createHttpClient: () {
            final client = HttpClient();
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
            return client;
          },
        );

  static Future<dynamic> callApi({
    BuildContext? context,
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      log("=========== API REQUEST ===========");
      log("METHOD : GET");
      log("URL    :${AppConstants.baseUrl}$url");
      log("BODY   : ${body ?? {}}");
      log("QUERY  : ${queryParams ?? {}}");
      log("===================================");

      final response = await dio.get(
        "${AppConstants.baseUrl}$url",
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
        if (context != null) {
          // ignore: use_build_context_synchronously
          AppMessage.show(context, "Server Error : ${response.statusCode}");
        }
        return null;
      }
    } on DioException catch (e) {
      log("TYPE: ${e.type}");
      log("MESSAGE: ${e.message}");
      log("ERROR: ${e.error}");
      log("RESPONSE: ${e.response?.data}");
      log("STATUS: ${e.response?.statusCode}");
      log("DIO ERROR : ${e.message}");

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // ignore: use_build_context_synchronously
        if (context != null) AppMessage.show(context, "Connection timed out");
      } else if (e.type == DioExceptionType.connectionError) {
        // ignore: use_build_context_synchronously
        if (context != null) AppMessage.show(context, "No Internet Connection");
      } else if (e.response != null) {
        if (context != null) {
          // ignore: use_build_context_synchronously
          AppMessage.show(context, "Server Error : ${e.response?.statusCode}");
        }
      } else {
        if (context != null) {
          // ignore: use_build_context_synchronously
          // AppMessage.show(context, e.message ?? "Unknown Error");
        }
      }

      return null;
    } catch (e) {
      log("UNKNOWN ERROR : $e");
      // ignore: use_build_context_synchronously
      if (context != null) AppMessage.show(context, e.toString());
      return null;
    }
  }
}

//post api service
class PostApiServices {
  static final Dio dio =
      Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
          ),
        )
        ..httpClientAdapter = IOHttpClientAdapter(
          createHttpClient: () {
            final client = HttpClient();
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
            return client;
          },
        );

  static Future<dynamic> callApi({
    BuildContext? context,
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      log("=========== API REQUEST ===========");
      log("METHOD : POST");
      log("URL    : ${AppConstants.baseUrl}$url");
      if (body is FormData) {
        log('FORM DATA FIELDS:');

        for (final field in body.fields) {
          log('${field.key} : ${field.value}');
        }

        log('FORM DATA FILES:');

        for (final file in body.files) {
          log(
            '${file.key} : '
            '${file.value.filename} '
            '(${file.value.length} bytes)',
          );
        }
      } else {
        log('BODY : ${body ?? {}}');
      }
      log("QUERY  : ${queryParams ?? {}}");
      log("===================================");

      final response = await dio.post(
        "${AppConstants.baseUrl}$url",
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
        if (context != null) {
          // ignore: use_build_context_synchronously
          AppMessage.show(context, "Server Error : ${response.statusCode}");
        }
        return null;
      }
    } on DioException catch (e) {
      log("DIO ERROR : ${e.message}");

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // ignore: use_build_context_synchronously
        if (context != null) AppMessage.show(context, "Connection timed out");
      } else if (e.type == DioExceptionType.connectionError) {
        // ignore: use_build_context_synchronously
        if (context != null) AppMessage.show(context, "No Internet Connection");
      } else if (e.response != null) {
        if (context != null) {
          // ignore: use_build_context_synchronously
          AppMessage.show(context, "Server Error : ${e.response?.statusCode}");
        }
      } else {
        if (context != null) {
          // ignore: use_build_context_synchronously
          AppMessage.show(context, e.message ?? "Unknown Error");
        }
      }

      return null;
    } catch (e) {
      log("UNKNOWN ERROR : $e");
      // ignore: use_build_context_synchronously
      if (context != null) AppMessage.show(context, e.toString());
      return null;
    }
  }
}
