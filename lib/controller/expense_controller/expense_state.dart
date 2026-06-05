import 'package:doctor_visit/model/day_expense_model.dart';
import 'package:doctor_visit/model/progress_percentage/progress_percentage_response_model.dart';
import 'package:doctor_visit/model/progress_percentage/today_expense_history_response_model.dart';
import 'package:doctor_visit/model/progress_percentage/weekly_expense_response_model.dart';

import 'package:flutter/material.dart';

class ExpenseState {
  final bool isEditLoading;
  final num totalExpense;
  final int weeklyListIndex;
  num? weekEotalExpense;

  final bool isExpanded;
  final bool isExpandedHistory;
  final num progressValue;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final List<ProgressPercentageResponseModel> progressPeercentage;
  final List<Expense> todayExpenseList;
  final List<WeeklyExpenseResponseModel> weeklyExpenseHistory;
  final List<ExpenseLists> weeklyExpenseSeperatedDate;

  final int category;

  final List<DayExpenseModel> expenseList;

  ExpenseState({
    this.weekEotalExpense = 0,
    this.weeklyListIndex = 0,
    this.isEditLoading = false,
    this.progressValue = 0,
    this.totalExpense = 0,
    this.expenseList = const [],
    this.weeklyExpenseSeperatedDate = const [],

    this.progressPeercentage = const [],
    this.todayExpenseList = const [],
    this.weeklyExpenseHistory = const [],

    this.isExpanded = false,
    this.isExpandedHistory = false,

    this.category = 1,
    required this.amountController,
    required this.descriptionController,
  });

  ExpenseState copyWith({
    TextEditingController? amountController,
    TextEditingController? descriptionController,
    int? weeklyListIndex,
    bool? isEditLoading,
    num? progressValue,
    int? category,
    List<ExpenseLists>? weeklyExpenseSeperatedDate,
    List<WeeklyExpenseResponseModel>? weeklyExpenseHistory,
    num? totalExpense,
    num? weekEotalExpense,

    bool? isExpanded,
    bool? isExpandedHistory,
    List<Expense>? todayExpenseList,
    List<DayExpenseModel>? expenseList,
    List<ProgressPercentageResponseModel>? progressPeercentage,
  }) {
    return ExpenseState(
      weeklyListIndex: weeklyListIndex ?? this.weeklyListIndex,
      isEditLoading: isEditLoading ?? this.isEditLoading,
      weeklyExpenseSeperatedDate:
          weeklyExpenseSeperatedDate ?? this.weeklyExpenseSeperatedDate,
      weekEotalExpense: weekEotalExpense ?? this.weekEotalExpense,
      descriptionController:
          descriptionController ?? this.descriptionController,
      amountController: amountController ?? this.amountController,
      progressValue: progressValue ?? this.progressValue,
      totalExpense: totalExpense ?? this.totalExpense,

      isExpanded: isExpanded ?? this.isExpanded,
      weeklyExpenseHistory: weeklyExpenseHistory ?? this.weeklyExpenseHistory,
      expenseList: expenseList ?? this.expenseList,
      todayExpenseList: todayExpenseList ?? this.todayExpenseList,
      category: category ?? this.category,
      isExpandedHistory: isExpandedHistory ?? this.isExpandedHistory,
      progressPeercentage: progressPeercentage ?? this.progressPeercentage,
    );
  }
}
