// To parse this JSON data, do
//
//     final proProfileDetailsResponseModel = proProfileDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

ProProfileDetailsResponseModel proProfileDetailsResponseModelFromJson(
  String str,
) => ProProfileDetailsResponseModel.fromJson(json.decode(str));

String proProfileDetailsResponseModelToJson(
  ProProfileDetailsResponseModel data,
) => json.encode(data.toJson());

class ProProfileDetailsResponseModel {
  bool? status;
  String? message;
  List<Detail>? details;

  ProProfileDetailsResponseModel({this.status, this.message, this.details});

  factory ProProfileDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      ProProfileDetailsResponseModel(
        status: json["status"],
        message: json["message"],
        details: json["Details"] == null
            ? []
            : List<Detail>.from(
                json["Details"]!.map((x) => Detail.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "Details": details == null
        ? []
        : List<dynamic>.from(details!.map((x) => x.toJson())),
  };
}

class Detail {
  String? name;
  String? mobile;
  String? address;
  String? image;
  String? email;

  Detail({this.name, this.mobile, this.address, this.image, this.email});

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    name: json["Name"],
    mobile: json["Mobile"],
    address: json["Address"],
    image: json["Image"],
    email: json["Email"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Mobile": mobile,
    "Address": address,
    "Image": image,
    "Email": email,
  };
}
