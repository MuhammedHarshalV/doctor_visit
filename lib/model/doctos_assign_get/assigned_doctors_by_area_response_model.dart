// To parse this JSON data, do
//
//     final assignedDoctorByAreaResponseModel = assignedDoctorByAreaResponseModelFromJson(jsonString);

import 'dart:convert';

AssignedDoctorByAreaResponseModel assignedDoctorByAreaResponseModelFromJson(
  String str,
) => AssignedDoctorByAreaResponseModel.fromJson(json.decode(str));

String assignedDoctorByAreaResponseModelToJson(
  AssignedDoctorByAreaResponseModel data,
) => json.encode(data.toJson());

class AssignedDoctorByAreaResponseModel {
  bool? status;
  String? message;
  List<DrList>? drList;

  AssignedDoctorByAreaResponseModel({this.status, this.message, this.drList});

  factory AssignedDoctorByAreaResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => AssignedDoctorByAreaResponseModel(
    status: json["status"],
    message: json["message"],
    drList: json["DrList"] == null
        ? []
        : List<DrList>.from(json["DrList"]!.map((x) => DrList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "DrList": drList == null
        ? []
        : List<dynamic>.from(drList!.map((x) => x.toJson())),
  };
}

class DrList {
  String? drName;
  int? drId;
  int? assignedProId;
  String? assignedProName;
  DateTime? assignedDate;
  DateTime? lastVisit;

  DrList({
    this.drName,
    this.drId,
    this.assignedProId,
    this.assignedProName,
    this.assignedDate,
    this.lastVisit,
  });

  factory DrList.fromJson(Map<String, dynamic> json) => DrList(
    drName: json["DrName"],
    drId: json["DrId"],
    assignedProId: json["AssignedProId"],
    assignedProName: json["AssignedProName"],
    assignedDate: json["AssignedDate"] == null
        ? null
        : DateTime.parse(json["AssignedDate"]),
    lastVisit: json["LastVisit"] == null
        ? null
        : DateTime.parse(json["LastVisit"]),
  );

  Map<String, dynamic> toJson() => {
    "DrName": drName,
    "DrId": drId,
    "AssignedProId": assignedProId,
    "AssignedProName": assignedProName,
    "AssignedDate": assignedDate?.toIso8601String(),
    "LastVisit": lastVisit?.toIso8601String(),
  };
}
