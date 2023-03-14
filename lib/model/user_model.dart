// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.status,
    this.message,
    this.userInfo,
  });

  bool? status;
  String? message;
  UserInfo? userInfo;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    status: json["status"],
    message: json["message"],
    userInfo: UserInfo.fromJson(json["userInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "userInfo": userInfo!.toJson(),
  };
}

class UserInfo {
  UserInfo({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.dob,
    this.profile,
    this.gender,
    this.userType,
    this.status,
    this.userToken,
    this.deviceToken,
    this.forgotid,
    this.createdAt,
    this.updatedAt,
    this.schoolName,
    this.subDivision,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  String? dob;
  String? profile;
  String? gender;
  int? userType;
  int? status;
  String? userToken;
  String? deviceToken;
  dynamic forgotid;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? schoolName;
  String? subDivision;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    dob: json["dob"],
    profile: json["profile"],
    gender: json["gender"],
    userType: json["user_type"],
    status: json["status"],
    userToken: json["user_token"],
    deviceToken: json["device_token"],
    forgotid: json["forgotid"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    schoolName: json["school_name"],
    subDivision: json["sub_division"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "dob": dob,
    "profile": profile,
    "gender": gender,
    "user_type": userType,
    "status": status,
    "user_token": userToken,
    "device_token": deviceToken,
    "forgotid": forgotid,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "school_name": schoolName,
    "sub_division": subDivision,
  };
}
