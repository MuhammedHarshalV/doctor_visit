import 'package:doctor_visit/model/day_expense_model.dart';

class ExpenseState {
  final int totalExpense;
  final bool isExpanded;
  final bool isExpandedHistory;

  final int category;

  final List<DayExpenseModel> expenseList;

  ExpenseState({
    required this.totalExpense,
    this.expenseList = const [],
    this.isExpanded = false,
    this.isExpandedHistory = false,

    required this.category,
  });

  ExpenseState copyWith({
    int? category,
    int? totalExpense,
    bool? isExpanded,
    bool? isExpandedHistory,
    List<DayExpenseModel>? expenseList,
  }) {
    return ExpenseState(
      totalExpense: totalExpense ?? this.totalExpense,
      isExpanded: isExpanded ?? this.isExpanded,
      expenseList: expenseList ?? this.expenseList,
      category: category ?? this.category,
      isExpandedHistory: isExpandedHistory ?? this.isExpandedHistory,
    );
  }
}
