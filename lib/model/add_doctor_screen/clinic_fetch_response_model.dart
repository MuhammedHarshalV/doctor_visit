// To parse this JSON data, do
//
//     final clinicFetchResponseModel = clinicFetchResponseModelFromJson(jsonString);

import 'dart:convert';

ClinicFetchResponseModel clinicFetchResponseModelFromJson(String str) =>
    ClinicFetchResponseModel.fromJson(json.decode(str));

String clinicFetchResponseModelToJson(ClinicFetchResponseModel data) =>
    json.encode(data.toJson());

class ClinicFetchResponseModel {
  bool? status;
  String? message;
  List<Clinic>? clinics;

  ClinicFetchResponseModel({this.status, this.message, this.clinics});

  factory ClinicFetchResponseModel.fromJson(Map<String, dynamic> json) =>
      ClinicFetchResponseModel(
        status: json["status"],
        message: json["message"],
        clinics: json["clinics"] == null
            ? []
            : List<Clinic>.from(
                json["clinics"]!.map((x) => Clinic.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "clinics": clinics == null
        ? []
        : List<dynamic>.from(clinics!.map((x) => x.toJson())),
  };
}

class Clinic {
  int? ahMstKey;
  String? ahMstPName;
  AhMstType? ahMstType;

  Clinic({this.ahMstKey, this.ahMstPName, this.ahMstType});

  factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(
    ahMstKey: json["AhMst_Key"],
    ahMstPName: json["AhMst_pName"],
    ahMstType: ahMstTypeValues.map[json["AhMst_Type"]]!,
  );

  Map<String, dynamic> toJson() => {
    "AhMst_Key": ahMstKey,
    "AhMst_pName": ahMstPName,
    "AhMst_Type": ahMstTypeValues.reverse[ahMstType],
  };
}

// ignore: constant_identifier_names
enum AhMstType { HOSP }

final ahMstTypeValues = EnumValues({"Hosp": AhMstType.HOSP});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
