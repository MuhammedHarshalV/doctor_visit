import 'package:doctor_visit/model/day_expense_model.dart';
import 'package:doctor_visit/model/progress_percentage/progress_percentage_response_model.dart';

class ExpenseState {
  final int totalExpense;
  final bool isExpanded;
  final bool isExpandedHistory;
  final List<ProgressPercentageResponseModel> progressPeercentage;

  final int category;

  final List<DayExpenseModel> expenseList;

  ExpenseState({
    this.totalExpense = 0,
    this.expenseList = const [],
    this.progressPeercentage = const [],

    this.isExpanded = false,
    this.isExpandedHistory = false,

    this.category = 1,
  });

  ExpenseState copyWith({
    int? category,
    int? totalExpense,
    bool? isExpanded,
    bool? isExpandedHistory,
    List<DayExpenseModel>? expenseList,
    List<ProgressPercentageResponseModel>? progressPeercentage,
  }) {
    return ExpenseState(
      totalExpense: totalExpense ?? this.totalExpense,
      isExpanded: isExpanded ?? this.isExpanded,
      expenseList: expenseList ?? this.expenseList,
      category: category ?? this.category,
      isExpandedHistory: isExpandedHistory ?? this.isExpandedHistory,
      progressPeercentage: progressPeercentage ?? this.progressPeercentage,
    );
  }
}
