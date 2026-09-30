import 'dart:typed_data';

import 'package:doctor_visit/model/expense_keys/get_expense_keys_response_model.dart';
import 'package:doctor_visit/model/progress_percentage/progress_percentage_response_model.dart';
import 'package:doctor_visit/model/progress_percentage/today_expense_history_response_model.dart';
import 'package:doctor_visit/model/progress_percentage/weekly_expense_response_model.dart';

import 'package:flutter/material.dart';

class ExpenseState {
  final bool isEditLoading;
  final bool isKmStart;

  final num totalExpense;
  final Uint8List base64Image;
  final String imagePath;
  final String startImagePath;
  final String startNetworkImageUrl;

  final String endImagePath;
  final String endNetworkImageUrl;

  final int weeklyListIndex;
  num? weekEotalExpense;
  final String base64toApi;
  final bool isExpanded;
  final bool isExpandedHistory;
  final num progressValue;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final List<ProgressPercentageResponseModel> progressPeercentage;
  final List<Expense> todayExpenseList;
  final List<WeeklyExpenseResponseModel> weeklyExpenseHistory;
  final List<ExpenseLists> weeklyExpenseSeperatedDate;
  final List<Accountvalue> expenseKeyList;

  final int category;

  ExpenseState({
    this.imagePath = '',
    this.startImagePath = '',
    this.startNetworkImageUrl = '',
    this.endImagePath = '',
    this.endNetworkImageUrl = '',
    this.base64toApi = '',
    Uint8List? base64Image,
    this.weekEotalExpense = 0,
    this.weeklyListIndex = 0,
    this.isEditLoading = false,
    this.isKmStart = false,
    this.progressValue = 0,
    this.totalExpense = 0,
    this.expenseKeyList = const [],
    this.weeklyExpenseSeperatedDate = const [],

    this.progressPeercentage = const [],
    this.todayExpenseList = const [],
    this.weeklyExpenseHistory = const [],

    this.isExpanded = false,
    this.isExpandedHistory = false,

    this.category = 1,
    required this.amountController,
    required this.descriptionController,
  }) : base64Image = base64Image ?? Uint8List(0);

  ExpenseState copyWith({
    String? base64toApi,
    String? imagePath,
    String? startImagePath,
    String? startNetworkImageUrl,
    String? endImagePath,
    String? endNetworkImageUrl,
    bool? isKmStart,
    TextEditingController? amountController,
    TextEditingController? descriptionController,
    Uint8List? base64Image,
    int? weeklyListIndex,
    bool? isEditLoading,
    num? progressValue,
    int? category,
    List<ExpenseLists>? weeklyExpenseSeperatedDate,
    List<Accountvalue>? expenseKeyList,
    List<WeeklyExpenseResponseModel>? weeklyExpenseHistory,
    num? totalExpense,
    num? weekEotalExpense,

    bool? isExpanded,
    bool? isExpandedHistory,
    List<Expense>? todayExpenseList,

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
      isKmStart: isKmStart ?? this.isKmStart,
      amountController: amountController ?? this.amountController,
      progressValue: progressValue ?? this.progressValue,
      totalExpense: totalExpense ?? this.totalExpense,
      base64Image: base64Image ?? this.base64Image,
      isExpanded: isExpanded ?? this.isExpanded,
      imagePath: imagePath ?? this.imagePath,
      startImagePath: startImagePath ?? this.startImagePath,
      startNetworkImageUrl: startNetworkImageUrl ?? this.startNetworkImageUrl,
      endImagePath: endImagePath ?? this.endImagePath,
      endNetworkImageUrl: endNetworkImageUrl ?? this.endNetworkImageUrl,
      weeklyExpenseHistory: weeklyExpenseHistory ?? this.weeklyExpenseHistory,
      expenseKeyList: expenseKeyList ?? this.expenseKeyList,
      todayExpenseList: todayExpenseList ?? this.todayExpenseList,
      category: category ?? this.category,
      isExpandedHistory: isExpandedHistory ?? this.isExpandedHistory,
      progressPeercentage: progressPeercentage ?? this.progressPeercentage,
      base64toApi: base64toApi ?? this.base64toApi,
    );
  }
}
