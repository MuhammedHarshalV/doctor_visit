// To parse this JSON data, do
//
//     final isGoingResponseModel = isGoingResponseModelFromJson(jsonString);

import 'dart:convert';

IsGoingResponseModel isGoingResponseModelFromJson(String str) =>
    IsGoingResponseModel.fromJson(json.decode(str));

String isGoingResponseModelToJson(IsGoingResponseModel data) =>
    json.encode(data.toJson());

class IsGoingResponseModel {
  bool? status;
  String? message;

  IsGoingResponseModel({this.status, this.message});

  factory IsGoingResponseModel.fromJson(Map<String, dynamic> json) =>
      IsGoingResponseModel(status: json["status"], message: json["message"]);

  Map<String, dynamic> toJson() => {"status": status, "message": message};
}
