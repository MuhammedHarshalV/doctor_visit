// ignore: file_names
// To parse this JSON data, do
//
//     final areaOrSpecialityFetchResponseModel = areaOrSpecialityFetchResponseModelFromJson(jsonString);

import 'dart:convert';

AreaOrSpecialityFetchResponseModel areaOrSpecialityFetchResponseModelFromJson(
  String str,
) => AreaOrSpecialityFetchResponseModel.fromJson(json.decode(str));

String areaOrSpecialityFetchResponseModelToJson(
  AreaOrSpecialityFetchResponseModel data,
) => json.encode(data.toJson());

class AreaOrSpecialityFetchResponseModel {
  bool? status;
  String? message;
  List<Datum>? data;

  AreaOrSpecialityFetchResponseModel({this.status, this.message, this.data});

  factory AreaOrSpecialityFetchResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => AreaOrSpecialityFetchResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? key;
  String? desc;
  String? type;

  Datum({this.key, this.desc, this.type});

  factory Datum.fromJson(Map<String, dynamic> json) =>
      Datum(key: json["Key"], desc: json["Desc"], type: json["Type"]);

  Map<String, dynamic> toJson() => {"Key": key, "Desc": desc, "Type": type};
}
