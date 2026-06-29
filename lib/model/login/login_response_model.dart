// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  bool? success;
  String? message;
  String? empid;
  String? username;
  int? yrId;
  bool? proAssignDr;

  LoginResponseModel({
    this.success,
    this.message,
    this.empid,
    this.username,
    this.yrId,
    this.proAssignDr,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        success: json["Success"],
        message: json["message"],
        empid: json["Empid"],
        username: json["username"],
        yrId: json["YrId"],
        proAssignDr: json["ProAssignDr"],
      );

  Map<String, dynamic> toJson() => {
    "Success": success,
    "message": message,
    "Empid": empid,
    "username": username,
    "YrId": yrId,
    "ProAssignDr": proAssignDr,
  };
}
