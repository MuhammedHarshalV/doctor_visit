import 'dart:developer';

import 'package:doctor_visit/apis/expenses/progress_percentage_api.dart';
import 'package:doctor_visit/controller/expense_controller/expense_state.dart';
import 'package:doctor_visit/controller/doctor_visit_controller/doctor_visit_state.dart';
import 'package:doctor_visit/model/day_expense_model.dart';
import 'package:doctor_visit/model/progress_percentage/progress_percentage_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class ExpenseController extends StateNotifier<ExpenseState> {
  ExpenseController() : super(ExpenseState()) {
    iniatialCall();
  }
  @override
  void dispose() {
    log("ExpenseController disposed");
    super.dispose();
  }

  Future<void> iniatialCall() async {
    //  await checkDatabaseStatus();
    await getProgressPercentage();
  }

  //progress_api
  Future<void> getProgressPercentage() async {
    final ProgressPercentageResponseModel response =
        await GetProgressPercentage.getProgressPercentage();
    state = state.copyWith(progressPeercentage: [response]);

    log('response from controller: ${response.toString()}');
  }

  //  Open Box ──
  Future<Box> _openBox() async {
    if (Hive.isBoxOpen('ExpenseList')) {
      return Hive.box('ExpenseList');
    }
    return await Hive.openBox('ExpenseList');
  }

  void getTotalExpenseAmount() {
    int total = 0;

    for (var item in state.expenseList) {
      total += int.parse(item.amount);
    }
    state = state.copyWith(totalExpense: total);
  }

  //  Read All
  Future<void> checkDatabaseStatus() async {
    try {
      //state = state.copyWith();

      final box = await _openBox();

      final List<DayExpenseModel> expenseList = box.values.map((e) {
        final map = Map<String, dynamic>.from(e);

        return DayExpenseModel(
          typeOfExpense: map['typeOfExpense'] ?? '',
          amount: map['amount'] ?? '',
          bill: map['bill'] ?? '',
          note: map['note'] ?? '',
        );
      }).toList();

      log('All History data: $expenseList');

      state = state.copyWith(expenseList: expenseList);
    } catch (e) {
      log('checkDatabaseStatus error: $e');
    }
    getTotalExpenseAmount();
  }

  //  Save to Doctors
  Future<bool> saveToHive({
    required String typeOfExpense,
    required String amount,
    required String bill,
    required String note,
  }) async {
    try {
      final box = await _openBox();

      final requestData = {
        "typeOfExpense": typeOfExpense,
        'amount': amount,
        "bill": bill,
        "note": note,
      };

      await box.add(requestData);
      checkDatabaseStatus();
      log('Saved: $requestData');
      return true;
    } catch (e) {
      log('saveToHive error: $e');
      return false;
    }
  }

  void updateISExpanded(bool isexpanded) {
    state = state.copyWith(isExpanded: isexpanded);
  }

  void updateISExpandedHistory(bool isExpandedHistory) {
    state = state.copyWith(isExpandedHistory: isExpandedHistory);
  }

  void updateCategory(int category) {
    state = state.copyWith(category: category);
  }
}

final dayExpenseProvider =
    StateNotifierProvider<ExpenseController, ExpenseState>(
      (ref) => ExpenseController(),
    );
