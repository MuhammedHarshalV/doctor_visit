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
  int? invno;
  dynamic accountvalues;
  List<Mastervalue>? mastervalues;
  dynamic testvalues;
  dynamic testRefValues;
  dynamic feeMstDtls;

  ExpenseKeysResponseModel({
    this.success,
    this.message,
    this.invno,
    this.accountvalues,
    this.mastervalues,
    this.testvalues,
    this.testRefValues,
    this.feeMstDtls,
  });

  factory ExpenseKeysResponseModel.fromJson(Map<String, dynamic> json) =>
      ExpenseKeysResponseModel(
        success: json["success"],
        message: json["message"],
        invno: json["invno"],
        accountvalues: json["Accountvalues"],
        mastervalues: json["Mastervalues"] == null
            ? []
            : List<Mastervalue>.from(
                json["Mastervalues"]!.map((x) => Mastervalue.fromJson(x)),
              ),
        testvalues: json["Testvalues"],
        testRefValues: json["testRefValues"],
        feeMstDtls: json["feeMstDtls"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "invno": invno,
    "Accountvalues": accountvalues,
    "Mastervalues": mastervalues == null
        ? []
        : List<dynamic>.from(mastervalues!.map((x) => x.toJson())),
    "Testvalues": testvalues,
    "testRefValues": testRefValues,
    "feeMstDtls": feeMstDtls,
  };
}

class Mastervalue {
  int? mstrkey;
  String? desc;
  String? mstrType;
  num? mstrvalue;
  String? mstrdetails;
  String? mstrcode;

  Mastervalue({
    this.mstrkey,
    this.desc,
    this.mstrType,
    this.mstrvalue,
    this.mstrdetails,
    this.mstrcode,
  });

  factory Mastervalue.fromJson(Map<String, dynamic> json) => Mastervalue(
    mstrkey: json["Mstrkey"],
    desc: json["Desc"],
    mstrType: json["MstrType"],
    mstrvalue: json["Mstrvalue"],
    mstrdetails: json["Mstrdetails"],
    mstrcode: json["Mstrcode"],
  );

  Map<String, dynamic> toJson() => {
    "Mstrkey": mstrkey,
    "Desc": desc,
    "MstrType": mstrType,
    "Mstrvalue": mstrvalue,
    "Mstrdetails": mstrdetails,
    "Mstrcode": mstrcode,
  };
}
