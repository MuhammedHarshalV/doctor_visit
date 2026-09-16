// To parse this JSON data, do
//
//     final expenseKeysResponseModel = expenseKeysResponseModelFromJson(jsonString);

import 'dart:convert';

ExpenseKeysResponseModel expenseKeysResponseModelFromJson(String str) =>
    ExpenseKeysResponseModel.fromJson(json.decode(str));

String expenseKeysResponseModelToJson(ExpenseKeysResponseModel data) =>
    json.encode(data.toJson());

class ExpenseKeysResponseModel {
  bool? success;
  String? message;
  num? invno;
  List<Accountvalue>? accountvalues;
  List<dynamic>? testRefValues;

  ExpenseKeysResponseModel({
    this.success,
    this.message,
    this.invno,
    this.accountvalues,
    this.testRefValues,
  });

  factory ExpenseKeysResponseModel.fromJson(Map<String, dynamic> json) =>
      ExpenseKeysResponseModel(
        success: json["success"],
        message: json["message"],
        invno: json["invno"],
        accountvalues: json["Accountvalues"] == null
            ? []
            : List<Accountvalue>.from(
                json["Accountvalues"]!.map((x) => Accountvalue.fromJson(x)),
              ),
        testRefValues: json["testRefValues"] == null
            ? []
            : List<dynamic>.from(json["testRefValues"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "invno": invno,
    "Accountvalues": accountvalues == null
        ? []
        : List<dynamic>.from(accountvalues!.map((x) => x.toJson())),
    "testRefValues": testRefValues == null
        ? []
        : List<dynamic>.from(testRefValues!.map((x) => x)),
  };
}

class Accountvalue {
  num? ahmstkey;
  String? pname;
  String? type;
  String? grpid;
  num? hospid;

  Accountvalue({this.ahmstkey, this.pname, this.type, this.grpid, this.hospid});

  factory Accountvalue.fromJson(Map<String, dynamic> json) => Accountvalue(
    ahmstkey: json["Ahmstkey"],
    pname: json["Pname"],
    type: json["Type"],
    grpid: json["Grpid"],
    hospid: json["Hospid"],
  );

  Map<String, dynamic> toJson() => {
    "Ahmstkey": ahmstkey,
    "Pname": pname,
    "Type": type,
    "Grpid": grpid,
    "Hospid": hospid,
  };
}
