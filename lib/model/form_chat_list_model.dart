// To parse this JSON data, do
//
//     final formChatListModel = formChatListModelFromJson(jsonString);

import 'dart:convert';

FormChatListModel formChatListModelFromJson(String str) => FormChatListModel.fromJson(json.decode(str));

String formChatListModelToJson(FormChatListModel data) => json.encode(data.toJson());

class FormChatListModel {
  FormChatListModel({
    this.status,
    this.message,
    this.formChatList,
  });

  bool? status;
  String? message;
  List<FormChatList>? formChatList;

  factory FormChatListModel.fromJson(Map<String, dynamic> json) => FormChatListModel(
    status: json["status"],
    message: json["message"],
    formChatList: List<FormChatList>.from(json["data"].map((x) => FormChatList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(formChatList!.map((x) => x.toJson())),
  };
}

class FormChatList {
  FormChatList({
    this.id,
    this.userId,
    this.email,
    this.phone,
    this.subject,
    this.message,
    this.replay,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? email;
  String? phone;
  String? subject;
  String? message;
  dynamic replay;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory FormChatList.fromJson(Map<String, dynamic> json) => FormChatList(
    id: json["id"],
    userId: json["user_id"],
    email: json["email"],
    phone: json["phone"],
    subject: json["subject"],
    message: json["message"],
    replay: json["replay"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "email": email,
    "phone": phone,
    "subject": subject,
    "message": message,
    "replay": replay,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
