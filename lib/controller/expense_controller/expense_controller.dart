import 'dart:developer';

import 'package:doctor_visit/apis/expenses/edit_today_expense_api.dart';
import 'package:doctor_visit/apis/expenses/progress_percentage_api.dart';
import 'package:doctor_visit/apis/expenses/today_expense_get_api.dart';
import 'package:doctor_visit/apis/expenses/weekly_expense_history_api.dart';
import 'package:doctor_visit/controller/expense_controller/expense_state.dart';

import 'package:doctor_visit/model/progress_percentage/progress_percentage_response_model.dart';
import 'package:doctor_visit/model/progress_percentage/today_expense_history_response_model.dart';
import 'package:doctor_visit/model/progress_percentage/weekly_expense_response_model.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseController extends StateNotifier<ExpenseState> {
  ExpenseController()
    : super(
        ExpenseState(
          amountController: TextEditingController(),
          descriptionController: TextEditingController(),
        ),
      ) {
    iniatialCall();
  }

  Future<void> iniatialCall() async {
    //  await checkDatabaseStatus();
    await getProgressPercentage();
    await todayExpenseHistory();
    await weeklyExpensesHistory();
  }

  //progress_api
  Future<void> getProgressPercentage() async {
    final ProgressPercentageResponseModel response =
        await GetProgressPercentage.getProgressPercentage();
    state = state.copyWith(progressPeercentage: [response]);
    if (state.progressPeercentage.isNotEmpty) {
      int value = state.progressPeercentage.first.percentage!.round();
      num progressValue = value / 100;
      state = state.copyWith(progressValue: progressValue);
    }
    log('response from controller: ${response.toString()}');
  }

  //today expense api
  Future<void> todayExpenseHistory() async {
    final TodayExpenseResponseModel response =
        await TodayExpenseGetApi.todayExpenseGetApi();
    state = state.copyWith(
      todayExpenseList: response.expenseList?.first.expenses ?? [],
    );
    state = state.copyWith(totalExpense: response.totalExpense);

    log('today expense list from controller: ${response.toString()}');
  }

  //edit expense api
  Future<void> editExpense({
    required BuildContext context,
    String? expenseAmount,
    String? expenseNote,
    String? expenseKey,
    String? expenseBill,
    String? expenseDiscr,
    String? employeeID,
    String? date,
    String? yearId,
  }) async {
    try {
      state = state.copyWith(isEditLoading: true);

      final TodayExpenseResponseModel? response =
          await EditTodayExpenseApi.editTodayExpenseApi(
            expenseAmount: expenseAmount,
            expenseNote: expenseNote,
            expenseKey: expenseKey,
            expenseBill: expenseBill,
            expenseDiscr: expenseDiscr,
            employeeID: employeeID,
            date: date,
            yearID: yearId,
          );
      log('today expense list from controller: ${response.toString()}');
      log('response: $response');

      if (response != null && response.status == true && employeeID == null) {
        log('Status true');

        if (!context.mounted) {
          log('Context not mounted');
          return;
        }

        Navigator.pop(context);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      await todayExpenseHistory();
      await weeklyExpensesHistory();
      state = state.copyWith(isEditLoading: false);
      state.descriptionController.clear();
      state.amountController.clear();
    }
  }

  //weekly expenses api
  Future<void> weeklyExpensesHistory() async {
    final WeeklyExpenseResponseModel? response =
        await WeeklyExpenseHistoryApi.weeklyExpenseHistoryApi();
    if (response == null) {
      state = state.copyWith(weeklyExpenseHistory: [], totalExpense: 0);
      return;
    }

    state = state.copyWith(
      weeklyExpenseHistory: [response],
      weeklyExpenseSeperatedDate: response.expenseList ?? [],
    );

    num total = 0;

    for (final expense
        in state.weeklyExpenseSeperatedDate[state.weeklyListIndex].expenses!) {
      total += expense.expAmt ?? 0;
    }

    state = state.copyWith(weekEotalExpense: total);

    log('weekly expense list from controller: ${response.toString()}');
  }

  void weeklyListChangeIcrease() {
    int weeklyLength = state.weeklyExpenseSeperatedDate.length - 1;
    if (state.weeklyListIndex == weeklyLength) {
    } else {
      state = state.copyWith(weeklyListIndex: state.weeklyListIndex + 1);
      num total = 0;

      for (final expense
          in state
              .weeklyExpenseSeperatedDate[state.weeklyListIndex]
              .expenses!) {
        total += expense.expAmt ?? 0;
      }

      state = state.copyWith(weekEotalExpense: total);
    }
  }

  void weeklyListChangeDecrease() {
    if (state.weeklyListIndex == 0) {
    } else {
      state = state.copyWith(weeklyListIndex: state.weeklyListIndex - 1);
      num total = 0;

      for (final expense
          in state
              .weeklyExpenseSeperatedDate[state.weeklyListIndex]
              .expenses!) {
        total += expense.expAmt ?? 0;
      }

      state = state.copyWith(weekEotalExpense: total);
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

  @override
  void dispose() {
    log("ExpenseController disposed");

    super.dispose();
  }
}

final dayExpenseProvider =
    StateNotifierProvider<ExpenseController, ExpenseState>(
      (ref) => ExpenseController(),
    );
