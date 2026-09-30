import 'dart:developer';
import 'dart:typed_data';

import 'package:doctor_visit/apis/expenses/edit_today_expense_api.dart';
import 'package:doctor_visit/apis/expenses/expense_key_checking_api.dart';
import 'package:doctor_visit/apis/expenses/get_kilometer_api.dart';
import 'package:doctor_visit/apis/expenses/progress_percentage_api.dart';
import 'package:doctor_visit/apis/expenses/today_expense_get_api.dart';
import 'package:doctor_visit/apis/expenses/weekly_expense_history_api.dart';
import 'package:doctor_visit/apis/work_completion_api/km_enter_api.dart';
import 'package:doctor_visit/controller/expense_controller/expense_state.dart';
import 'package:doctor_visit/core/api_errors/api_errors.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/model/expense_keys/get_expense_keys_response_model.dart';

import 'package:doctor_visit/model/progress_percentage/progress_percentage_response_model.dart';
import 'package:doctor_visit/model/progress_percentage/today_expense_history_response_model.dart';
import 'package:doctor_visit/model/progress_percentage/weekly_expense_response_model.dart';
import 'package:doctor_visit/model/work_completion_and_start_duty/work_completion_and_start_duty_response_model.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ExpenseController extends StateNotifier<ExpenseState> {
  ExpenseController()
    : super(
        ExpenseState(
          amountController: TextEditingController(),
          descriptionController: TextEditingController(),
        ),
      ) {
    iniatialCall();
    getKilometerApi();
  }
  // get kilometer api
  Future<void> getKilometerApi() async {
    final response = await GetKilometerApi.getKilometerApi();
    if (response != null && response["Status"] == true) {
      final result = response["result"];

      if (result != null) {
        startKmController.text = result["ProMst_StartKM"]?.toString() ?? '';

        endKmController.text = result["ProMst_EndKM"]?.toString() ?? '';
        state = state.copyWith(
          startNetworkImageUrl: result["ProMst_StartKMImg"] ?? '',
          endNetworkImageUrl: result["ProMst_EndKMImg"] ?? '',
        );
      } else {
        startKmController.clear();
        endKmController.clear();
      }
    }
  }

  void clearNetworkImageUrlStart(String path) {
    state = state.copyWith(startNetworkImageUrl: '', startImagePath: path);
  }

  void clearimagePathStart(String path) {
    state = state.copyWith(startNetworkImageUrl: '', startImagePath: '');
  }

  void clearNetworkImageUrlEnd(String path) {
    state = state.copyWith(endNetworkImageUrl: '', endImagePath: path);
  }

  void clearimagePathEnd(String path) {
    state = state.copyWith(endNetworkImageUrl: '', endImagePath: '');
  }

  void storeImageStart(String path) {
    state = state.copyWith(startNetworkImageUrl: '', startImagePath: path);
  }

  void storeImageEnd(String path) {
    state = state.copyWith(endNetworkImageUrl: '', endImagePath: path);
  }

  final TextEditingController startKmController = TextEditingController();
  final TextEditingController endKmController = TextEditingController();

  Future<void> kmEnterApi({
    required num? startKm,
    required num? endKm,
    required BuildContext context,
    required String? start,
    required String? end,
  }) async {
    try {
      state = state.copyWith(isKmStart: true);
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final WorkCompletionAndStartDutyResponseModel response =
          await KmEnterApi.kmEnterApi(
            startKmPhoto: start,
            endKmPhoto: end,
            date: currentDate,
            endKm: endKm,
            startKm: startKm,
          );
      if (response.status == true) {}
      log('==============$response');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'KM updated successfully',
            style: TextStyle(
              color: AppColors.appWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: AppColors.appGreen,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      log(e.toString());
    } finally {
      state = state.copyWith(isKmStart: false);
    }
  }

  Future<void> iniatialCall() async {
    getExpenseKeys();
    await getProgressPercentage();
    await todayExpenseHistory();
    await weeklyExpensesHistory();
  }

  //expense keys
  Future<void> getExpenseKeys() async {
    ExpenseKeysResponseModel? response = await GetExpenseKeys.getExpenseKeys();
    if (response == null || response.accountvalues?.isEmpty != false) {
      return;
    }
    final expenseList = response.accountvalues!
        .where((item) => item.type?.toLowerCase() == 'expense')
        .toList();

    state = state.copyWith(expenseKeyList: expenseList);
    log('''
===========================
Expenses are:
${state.expenseKeyList}
===========================
''');
  }

  //progress_api
  Future<void> getProgressPercentage() async {
    final ProgressPercentageResponseModel? response =
        await GetProgressPercentage.getProgressPercentage();
    if (response != null) {
      state = state.copyWith(progressPeercentage: [response]);
      if (state.progressPeercentage.isNotEmpty) {
        int value = state.progressPeercentage.first.percentage!.round();
        num progressValue = value / 100;
        state = state.copyWith(progressValue: progressValue);
      }
      log('response from controller: ${response.toString()}');
    }
  }

  void updateImage(Uint8List? image) {
    state = state.copyWith(base64Image: image);
  }

  void base64ToApiUpdate(String imageString) {
    state = state.copyWith(base64toApi: imageString);
  }

  //today expense api
  Future<void> todayExpenseHistory() async {
    final TodayExpenseResponseModel? response =
        await TodayExpenseGetApi.todayExpenseGetApi();
    if (response?.expenseList?.isNotEmpty == true) {
      state = state.copyWith(
        todayExpenseList: response?.expenseList!.first.expenses ?? [],
      );
      state = state.copyWith(totalExpense: response?.totalExpense);

      log('today expense list from controller: ${response.toString()}');
    }
  }

  //edit expense api
  Future<void> editExpense({
    required BuildContext context,
    String? expenseAmount,
    String? expenseNote,
    String? expenseKey,
    String? expenseEditKey,
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
            expenseEditKey: expenseEditKey,
          );
      log('today expense list from controller: ${response.toString()}');
      log('response: $response');

      if (response != null && response.status == true && date == null) {
        log('Status true');

        if (!context.mounted) {
          log('Context not mounted');
          return;
        }

        context.pop();
      } else {
        state = state.copyWith(base64toApi: '', base64Image: Uint8List(0));
      }
    } catch (e) {
      log(e.toString());
      // ignore: use_build_context_synchronously
      AppMessage.show(context, e.toString());
    } finally {
      state = state.copyWith(isEditLoading: false);
      state.descriptionController.clear();
      state.amountController.clear();
      await todayExpenseHistory();
      await weeklyExpensesHistory();
    }
  }

  //weekly expenses api
  Future<void> weeklyExpensesHistory() async {
    final WeeklyExpenseResponseModel? response =
        await WeeklyExpenseHistoryApi.weeklyExpenseHistoryApi();
    if (response == null || (response.expenseList ?? []).isEmpty) {
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
    StateNotifierProvider.autoDispose<ExpenseController, ExpenseState>(
      (ref) => ExpenseController(),
    );
