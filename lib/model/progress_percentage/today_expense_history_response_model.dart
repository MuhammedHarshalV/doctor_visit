// To parse this JSON data, do
//
//     final todayExpenseResponseModel = todayExpenseResponseModelFromJson(jsonString);

import 'dart:convert';

TodayExpenseResponseModel todayExpenseResponseModelFromJson(String str) =>
    TodayExpenseResponseModel.fromJson(json.decode(str));

String todayExpenseResponseModelToJson(TodayExpenseResponseModel data) =>
    json.encode(data.toJson());

class TodayExpenseResponseModel {
  bool? status;
  String? message;
  List<ExpenseList>? expenseList;
  num? totalExpense;

  TodayExpenseResponseModel({
    this.status,
    this.message,
    this.expenseList,
    this.totalExpense,
  });

  factory TodayExpenseResponseModel.fromJson(Map<String, dynamic> json) =>
      TodayExpenseResponseModel(
        status: json["status"],
        message: json["message"],
        expenseList: json["ExpenseList"] == null
            ? []
            : List<ExpenseList>.from(
                json["ExpenseList"]!.map((x) => ExpenseList.fromJson(x)),
              ),
        totalExpense: json["TotalExpense"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "ExpenseList": expenseList == null
        ? []
        : List<dynamic>.from(expenseList!.map((x) => x.toJson())),
    "TotalExpense": totalExpense,
  };
}

class ExpenseList {
  DateTime? date;
  List<Expense>? expenses;

  ExpenseList({this.date, this.expenses});

  factory ExpenseList.fromJson(Map<String, dynamic> json) => ExpenseList(
    date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
    expenses: json["Expenses"] == null
        ? []
        : List<Expense>.from(json["Expenses"]!.map((x) => Expense.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Date":
        "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "Expenses": expenses == null
        ? []
        : List<dynamic>.from(expenses!.map((x) => x.toJson())),
  };
}

class Expense {
  int? expKey;
  String? expNote;
  num? expAmt;
  dynamic expDesc;

  Expense({this.expKey, this.expNote, this.expAmt, this.expDesc});

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    expKey: json["Exp_Key"],
    expNote: json["Exp_Note"],
    expAmt: json["Exp_Amt"],
    expDesc: json["Exp_Desc"],
  );

  Map<String, dynamic> toJson() => {
    "Exp_Key": expKey,
    "Exp_Note": expNote,
    "Exp_Amt": expAmt,
    "Exp_Desc": expDesc,
  };
}
