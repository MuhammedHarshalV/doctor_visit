import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';

import 'package:doctor_visit/model/progress_percentage/today_expense_history_response_model.dart';
import 'package:intl/intl.dart';

class TodayExpenseGetApi {
  static Future<dynamic> todayExpenseGetApi() async {
    try {
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await GetApiServices.callApi(
        queryParams: {"expDate": currentDate, "EmpId": AppConstants.employeeID},
        url: "${ApiConstants.baseUrl}${ApiConstants.expenseHistory}",
      );

      if (response == null) {
        return null;
      }

      return TodayExpenseResponseModel.fromJson(response);
    } catch (e) {
      log("today expense history error : $e");
      return null;
    }
  }
}
