// To parse this JSON data, do
//
//     final weeklyExpenseResponseModel = weeklyExpenseResponseModelFromJson(jsonString);

import 'dart:convert';

WeeklyExpenseResponseModel weeklyExpenseResponseModelFromJson(String str) =>
    WeeklyExpenseResponseModel.fromJson(json.decode(str));

String weeklyExpenseResponseModelToJson(WeeklyExpenseResponseModel data) =>
    json.encode(data.toJson());

class WeeklyExpenseResponseModel {
  bool? status;
  String? message;
  List<ExpenseLists>? expenseList;
  num? totalExpense;

  WeeklyExpenseResponseModel({
    this.status,
    this.message,
    this.expenseList,
    this.totalExpense,
  });

  factory WeeklyExpenseResponseModel.fromJson(Map<String, dynamic> json) =>
      WeeklyExpenseResponseModel(
        status: json["status"],
        message: json["message"],
        expenseList: json["ExpenseList"] == null
            ? []
            : List<ExpenseLists>.from(
                json["ExpenseList"]!.map((x) => ExpenseLists.fromJson(x)),
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

class ExpenseLists {
  String? date;
  List<Expenses>? expenses;

  ExpenseLists({this.date, this.expenses});

  factory ExpenseLists.fromJson(Map<String, dynamic> json) => ExpenseLists(
    date: json["Date"] == null ? null : (json["Date"]),
    expenses: json["Expenses"] == null
        ? []
        : List<Expenses>.from(
            json["Expenses"]!.map((x) => Expenses.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "Date": date,
    "Expenses": expenses == null
        ? []
        : List<dynamic>.from(expenses!.map((x) => x.toJson())),
  };
}

class Expenses {
  int? expKey;
  String? expNote;
  num? expAmt;
  String? expDesc;
  int? expExpId;
  dynamic expIsApproved;
  dynamic expApprovedAmt;

  Expenses({
    this.expKey,
    this.expNote,
    this.expAmt,
    this.expDesc,
    this.expExpId,
    this.expIsApproved,
    this.expApprovedAmt,
  });

  factory Expenses.fromJson(Map<String, dynamic> json) => Expenses(
    expKey: json["Exp_Key"],
    expNote: json["Exp_Note"],
    expAmt: json["Exp_Amt"],
    expDesc: json["Exp_Desc"],
    expExpId: json["Exp_ExpId"],
    expIsApproved: json["Exp_isApproved"],
    expApprovedAmt: json["Exp_ApprovedAmt"],
  );

  Map<String, dynamic> toJson() => {
    "Exp_Key": expKey,
    "Exp_Note": expNote,
    "Exp_Amt": expAmt,
    "Exp_Desc": expDesc,
    "Exp_ExpId": expExpId,
    "Exp_isApproved": expIsApproved,
    "Exp_ApprovedAmt": expApprovedAmt,
  };
}
