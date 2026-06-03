// To parse this JSON data, do
//
//     final workCompletionAndStartDutyResponseModel = workCompletionAndStartDutyResponseModelFromJson(jsonString);

import 'dart:convert';

WorkCompletionAndStartDutyResponseModel workCompletionAndStartDutyResponseModelFromJson(String str) => WorkCompletionAndStartDutyResponseModel.fromJson(json.decode(str));

String workCompletionAndStartDutyResponseModelToJson(WorkCompletionAndStartDutyResponseModel data) => json.encode(data.toJson());

class WorkCompletionAndStartDutyResponseModel {
    bool? status;
    String? message;
    Data? data;

    WorkCompletionAndStartDutyResponseModel({
        this.status,
        this.message,
        this.data,
    });

    factory WorkCompletionAndStartDutyResponseModel.fromJson(Map<String, dynamic> json) => WorkCompletionAndStartDutyResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    int? proMstKey;
    int? proDetKey;

    Data({
        this.proMstKey,
        this.proDetKey,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        proMstKey: json["ProMst_Key"],
        proDetKey: json["ProDet_Key"],
    );

    Map<String, dynamic> toJson() => {
        "ProMst_Key": proMstKey,
        "ProDet_Key": proDetKey,
    };
}
