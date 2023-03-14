  // To parse this JSON data, do
//
//     final courseVideoModel = courseVideoModelFromJson(jsonString);

import 'dart:convert';

CourseVideoModel courseVideoModelFromJson(String str) => CourseVideoModel.fromJson(json.decode(str));

String courseVideoModelToJson(CourseVideoModel data) => json.encode(data.toJson());

class CourseVideoModel {
  CourseVideoModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<CourseVideo>? data;

  factory CourseVideoModel.fromJson(Map<String, dynamic> json) => CourseVideoModel(
    status: json["status"],
    message: json["message"],
    data: List<CourseVideo>.from(json["data"].map((x) => CourseVideo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CourseVideo {
  CourseVideo({
    this.sectionName,
    this.videos,
  });

  String? sectionName;
  List<Video>? videos;

  factory CourseVideo.fromJson(Map<String, dynamic> json) => CourseVideo(
    sectionName: json["section_name"],
    videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "section_name": sectionName,
    "videos": List<dynamic>.from(videos!.map((x) => x.toJson())),
  };
}

class Video {
  Video({
    this.id,
    this.topicId,
    this.sectionId,
    this.title,
    this.videoFile,
    this.videoLength,
    this.videoThumbnail,
    this.createdAt,
    this.updatedAt,
    this.iswatch,
    this.topicName,
    this.topicImage,
    this.mySectionName
  });

  int? id;
  int? topicId;
  int? sectionId;
  String? title;
  String? videoFile;
  String? videoLength;
  String? videoThumbnail;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic iswatch;
  String? topicName;
  String? topicImage;
  String? mySectionName;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"],
    topicId: json["topic_id"],
    sectionId: json["section_id"],
    title: json["title"],
    videoFile: json["video_file"],
    videoLength: json["video_length"],
    videoThumbnail: json["video_thumbnail"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    iswatch: json["iswatch"],
    topicName: json["topicName"],
    topicImage: json["topicImage"],
    mySectionName: json["mySectionName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "topic_id": topicId,
    "section_id": sectionId,
    "title": title,
    "video_file": videoFile,
    "video_length": videoLength,
    "video_thumbnail": videoThumbnail,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "iswatch": iswatch,
    "topicName": topicName,
    "topicImage": topicImage,
    "mySectionName": mySectionName,
  };
}
