// To parse this JSON data, do
//
//     final doctorsAssignResponseModel = doctorsAssignResponseModelFromJson(jsonString);

import 'dart:convert';

DoctorsAssignResponseModel doctorsAssignResponseModelFromJson(String str) =>
    DoctorsAssignResponseModel.fromJson(json.decode(str));

String doctorsAssignResponseModelToJson(DoctorsAssignResponseModel data) =>
    json.encode(data.toJson());

class DoctorsAssignResponseModel {
  bool? status;
  String? message;
  List<DrList>? drList;
  num? totDistance;

  DoctorsAssignResponseModel({
    this.status,
    this.message,
    this.drList,
    this.totDistance,
  });

  factory DoctorsAssignResponseModel.fromJson(Map<String, dynamic> json) =>
      DoctorsAssignResponseModel(
        status: json["status"],
        message: json["message"],
        drList: json["DrList"] == null
            ? []
            : List<DrList>.from(json["DrList"]!.map((x) => DrList.fromJson(x))),
        totDistance: json["TotDistance"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "DrList": drList == null
        ? []
        : List<dynamic>.from(drList!.map((x) => x.toJson())),
    "TotDistance": totDistance,
  };
}

class DrList {
  int? drId;
  String? drName;
  String? drPhone;
  String? drLocation;
  String? drAddress;
  bool? drIsGoing;
  dynamic visitStatus;

  DrList({
    this.drId,
    this.drName,
    this.drPhone,
    this.drLocation,
    this.drAddress,
    this.drIsGoing,
    this.visitStatus,
  });

  factory DrList.fromJson(Map<String, dynamic> json) => DrList(
    drId: json["DrId"],
    drName: json["DrName"],
    drPhone: json["DrPhone"],
    drLocation: json["DrLocation"],
    drAddress: json["DrAddress"],
    drIsGoing: json["DrIsGoing"],
    visitStatus: json["VisitStatus"],
  );

  Map<String, dynamic> toJson() => {
    "DrId": drId,
    "DrName": drName,
    "DrPhone": drPhone,
    "DrLocation": drLocation,
    "DrAddress": drAddress,
    "DrIsGoing": drIsGoing,
    "VisitStatus": visitStatus,
  };
}
