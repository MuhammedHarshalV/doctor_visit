// To parse this JSON data, do
//
//     final progressPercentageResponseModel = progressPercentageResponseModelFromJson(jsonString);

import 'dart:convert';

ProgressPercentageResponseModel progressPercentageResponseModelFromJson(
  String str,
) => ProgressPercentageResponseModel.fromJson(json.decode(str));

String progressPercentageResponseModelToJson(
  ProgressPercentageResponseModel data,
) => json.encode(data.toJson());

class ProgressPercentageResponseModel {
  bool? status;
  String? message;
  num? percentage;
  int? compltCount;
  int? upcoming;
  int? total;

  ProgressPercentageResponseModel({
    this.status,
    this.message,
    this.percentage,
    this.compltCount,
    this.upcoming,
    this.total,
  });

  factory ProgressPercentageResponseModel.fromJson(Map<String, dynamic> json) =>
      ProgressPercentageResponseModel(
        status: json["status"],
        message: json["message"],
        percentage: json["Percentage"]?.toDouble(),
        compltCount: json["CompltCount"],
        upcoming: json["Upcoming"],
        total: json["Total"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "Percentage": percentage,
    "CompltCount": compltCount,
    "Upcoming": upcoming,
    "Total": total,
  };
}
