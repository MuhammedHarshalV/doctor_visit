import 'dart:developer';
import 'package:doctor_visit/core/constants/api_constants.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/services/api_services/api_services.dart';
import 'package:doctor_visit/model/progress_percentage/weekly_expense_response_model.dart';

class WeeklyExpenseHistoryApi {
  static Future<dynamic> weeklyExpenseHistoryApi() async {
    try {
      final response = await GetApiServices.callApi(
        queryParams: {"expDate": '', "EmpId": AppConstants.employeeID},
        url: "${ApiConstants.baseUrl}${ApiConstants.expenseHistory}",
      );

      if (response == null) {
        return null;
      }

      return WeeklyExpenseResponseModel.fromJson(response);
    } catch (e) {
      log("weekly expense history error : $e");
      return null;
    }
  }
}
