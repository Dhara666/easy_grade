// To parse this JSON data, do
//
//     final courseModel = courseModelFromJson(jsonString);

import 'dart:convert';

CourseModel courseModelFromJson(String str) => CourseModel.fromJson(json.decode(str));

String courseModelToJson(CourseModel data) => json.encode(data.toJson());

class CourseModel {
  CourseModel({
    this.status,
    this.message,
    this.courseDetail,
  });

  bool? status;
  String? message;
  List<CourseDetail>?   courseDetail;

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
    status: json["status"],
    message: json["message"],
    courseDetail: List<CourseDetail>.from(json["data"].map((x) => CourseDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "CourseDetail": List<dynamic>.from(courseDetail!.map((x) => x.toJson())),
  };
}

class CourseDetail {
  CourseDetail({
    this.id,
    this.topicName,
    this.length,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.isCompleted,
    this.totalVideo,
    this.watchVideo,
    this.totalCommunity,
  });

  int? id;
  String? topicName;
  dynamic length;
  dynamic image;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? isCompleted;
  int? totalVideo;
  int? watchVideo;
  int? totalCommunity;

  factory CourseDetail.fromJson(Map<String, dynamic> json) => CourseDetail(
    id: json["id"],
    topicName: json["topic_name"],
    length: json["length"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isCompleted: json["is_completed"],
    totalVideo: json["total_video"],
    watchVideo: json["watch_video"],
    totalCommunity: json["total_community"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "topic_name": topicName,
    "length": length  ,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_completed": isCompleted,
    "total_video": totalVideo,
    "watch_video": watchVideo,
    "total_community": totalCommunity,
  };
}
