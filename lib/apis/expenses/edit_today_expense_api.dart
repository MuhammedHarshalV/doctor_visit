import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';

import 'package:doctor_visit/core/services/api_services/api_services.dart';

import 'package:doctor_visit/model/progress_percentage/today_expense_history_response_model.dart';

class EditTodayExpenseApi {
  static Future<dynamic> editTodayExpenseApi({
    required String? expenseAmount,
    required String? expenseNote,
    required String? expenseKey,
    required String? employeeID,
    required String? date,
    required String? yearID,
    required String? expenseEditKey,
    required String? expenseBill,
    required String? expenseDiscr,
  }) async {
    try {
      final Map<String, dynamic> expSend = {};
      if (employeeID != null) {
        expSend["Exp_EmpId"] = employeeID;
      }
      if (expenseKey != null) {
        expSend["Exp_ExpId"] = expenseKey;
      }
      if (date != null) {
        expSend["Exp_Date"] = date;
      }
      if (expenseEditKey != null) {
        expSend["Exp_Key"] = expenseEditKey;
      }
      if (yearID != null) {
        expSend["Exp_YrId"] = yearID;
      }

      if (expenseNote != null) {
        expSend["Exp_Note"] = expenseNote;
      }
      if (expenseAmount != null) {
        expSend["Exp_Amt"] = expenseAmount;
      }

      if (expenseBill != null) {
        expSend["Exp_BillImg"] = expenseBill;
      }
      if (expenseDiscr != null) {
        expSend["Exp_Desc"] = expenseDiscr;
      }
      final response = await PostApiServices.callApi(
        body: [expSend],
        url: "${ApiConstants.baseUrl}${ApiConstants.expenseSaveorEdit}",
      );

      if (response == null) {
        return null;
      }

      return TodayExpenseResponseModel.fromJson(response);
    } catch (e) {
      log("today expense edit time error : $e");
      return null;
    }
  }
}
