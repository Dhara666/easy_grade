import 'dart:convert';

AcademicCalenderModel academicCalenderModelFromJson(String str) => AcademicCalenderModel.fromJson(json.decode(str));

String academicCalenderModelToJson(AcademicCalenderModel data) => json.encode(data.toJson());

class AcademicCalenderModel {
  AcademicCalenderModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<CalenderDetail>? data;

  factory AcademicCalenderModel.fromJson(Map<String, dynamic> json) => AcademicCalenderModel(
    status: json["status"],
    message: json["message"],
    data: List<CalenderDetail>.from(json["data"].map((x) => CalenderDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CalenderDetail {
  CalenderDetail({
    this.id,
    this.eventName,
    this.eventDate,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? eventName;
  DateTime? eventDate;
  DateTime? createdAt;
  String? updatedAt;

  factory CalenderDetail.fromJson(Map<String, dynamic> json) => CalenderDetail(
    id: json["id"],
    eventName: json["event_name"],
    eventDate: DateTime.parse(json["event_date"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_name": eventName,
    "event_date": "${eventDate?.year.toString().padLeft(4, '0')}-${eventDate?.month.toString().padLeft(2, '0')}-${eventDate?.day.toString().padLeft(2, '0')}",
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
  };
}
