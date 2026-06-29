// To parse this JSON data, do
//
//     final weeklyAssignedDoctorResponseModel = weeklyAssignedDoctorResponseModelFromJson(jsonString);

import 'dart:convert';

WeeklyAssignedDoctorResponseModel weeklyAssignedDoctorResponseModelFromJson(
  String str,
) => WeeklyAssignedDoctorResponseModel.fromJson(json.decode(str));

String weeklyAssignedDoctorResponseModelToJson(
  WeeklyAssignedDoctorResponseModel data,
) => json.encode(data.toJson());

class WeeklyAssignedDoctorResponseModel {
  bool? status;
  String? message;
  List<WeeklyDrList>? weeklyDrList;

  WeeklyAssignedDoctorResponseModel({
    this.status,
    this.message,
    this.weeklyDrList,
  });

  factory WeeklyAssignedDoctorResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => WeeklyAssignedDoctorResponseModel(
    status: json["status"],
    message: json["message"],
    weeklyDrList: json["DrList"] == null
        ? []
        : List<WeeklyDrList>.from(
            json["DrList"]!.map((x) => WeeklyDrList.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "DrList": weeklyDrList == null
        ? []
        : List<dynamic>.from(weeklyDrList!.map((x) => x.toJson())),
  };
}

class WeeklyDrList {
  int? drId;
  String? drName;
  String? drPhone;
  String? drLocation;
  String? drAddress;
  bool? drIsGoing;
  DateTime? assignedDate;
  bool? drVisitStatus;
  WeeklyDrList({
    this.drId,
    this.drName,
    this.drPhone,
    this.drLocation,
    this.drAddress,
    this.drIsGoing,
    this.assignedDate,
    this.drVisitStatus,
  });

  factory WeeklyDrList.fromJson(Map<String, dynamic> json) => WeeklyDrList(
    drId: json["DrId"],
    drName: json["DrName"],
    drPhone: json["DrPhone"],
    drLocation: json["DrLocation"],
    drAddress: json["DrAddress"],
    drIsGoing: json["DrIsGoing"],
    assignedDate: json["AssignedDate"] == null
        ? null
        : DateTime.parse(json["AssignedDate"]),
    drVisitStatus: json["DrVisitStatus"],
  );

  Map<String, dynamic> toJson() => {
    "DrId": drId,
    "DrName": drName,
    "DrPhone": drPhone,
    "DrLocation": drLocation,
    "DrAddress": drAddress,
    "DrIsGoing": drIsGoing,
    "AssignedDate": assignedDate?.toIso8601String(),
    "DrVisitStatus": drVisitStatus,
  };
}
