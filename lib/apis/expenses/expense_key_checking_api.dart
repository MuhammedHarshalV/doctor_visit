import 'dart:developer';

import 'package:doctor_visit/core/constants/api_constants.dart';

import 'package:doctor_visit/core/services/api_services/api_services.dart';
import 'package:doctor_visit/model/expense_keys/get_expense_keys_response_model.dart';

class GetExpenseKeys {
  static Future<dynamic> getExpenseKeys() async {
    try {
      final response = await GetApiServices.callApi(
        queryParams: {"CmpyId": 0, "type": "AccountHeads"},
        url: ApiConstants.expenseKey,
      );

      if (response == null) {
        return null;
      }

      return ExpenseKeysResponseModel.fromJson(response);
    } catch (e) {
      log("expense keys Api error : $e");
      return null;
    }
  }
}
