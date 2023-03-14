import 'dart:convert';

/// get user community

UserCommunityModel userCommunityModelFromJson(String str) => UserCommunityModel.fromJson(json.decode(str));

String userCommunityModelToJson(UserCommunityModel data) => json.encode(data.toJson());

class UserCommunityModel {
  UserCommunityModel({
    this.status,
    this.message,
    this.userCommunity,
  });

  bool? status;
  String? message;
  List<UserCommunity>? userCommunity;

  factory UserCommunityModel.fromJson(Map<String, dynamic> json) => UserCommunityModel(
    status: json["status"],
    message: json["message"],
    userCommunity: List<UserCommunity>.from(json["data"].map((x) => UserCommunity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(userCommunity!.map((x) => x.toJson())),
  };
}

class UserCommunity {
  UserCommunity({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.files,
    this.views,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? title;
  String? description;
  String? files;
  int? views;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory UserCommunity.fromJson(Map<String, dynamic> json) => UserCommunity(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    description: json["description"],
    files: json["files"],
    views: json["views"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "description": description,
    "files": files,
    "views": views,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

/// get all community model

CommunityModel communityModelFromJson(String str) => CommunityModel.fromJson(json.decode(str));

String communityModelToJson(CommunityModel data) => json.encode(data.toJson());

class CommunityModel {
  CommunityModel({
    this.status,
    this.message,
    this.getAllCommunity,
  });

  bool? status;
  String? message;
  List<GetAllCommunity>? getAllCommunity;

  factory CommunityModel.fromJson(Map<String, dynamic> json) => CommunityModel(
    status: json["status"],
    message: json["message"],
    getAllCommunity: List<GetAllCommunity>.from(json["data"].map((x) => GetAllCommunity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(getAllCommunity!.map((x) => x.toJson())),
  };
}

class GetAllCommunity {
  GetAllCommunity({
    this.name,
    this.id,
    this.userId,
    this.title,
    this.description,
    this.files,
    this.tags,
    this.views,
    this.createdAt,
    this.updatedAt,
    this.profile,
    this.liked,
    this.disliked,
  });

  String? name;
  int? id;
  int? userId;
  String? title;
  String? description;
  String? files;
  dynamic tags;
  int? views;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? profile;
  int? liked;
  int? disliked;

  factory GetAllCommunity.fromJson(Map<String, dynamic> json) => GetAllCommunity(
    name: json["name"],
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    description: json["description"],
    files: json["files"],
    tags: json["tags"],
    views: json["views"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    profile: json["profile"],
    liked: json["liked"],
    disliked: json["disliked"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "user_id": userId,
    "title": title,
    "description": description,
    "files": files,
    "tags": tags,
    "views": views,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "profile": profile,
    "liked": liked,
    "disliked": disliked,
  };
}

/// answer model

CommunityAnswerModel communityAnswerModelFromJson(String str) => CommunityAnswerModel.fromJson(json.decode(str));

String communityAnswerModelToJson(CommunityAnswerModel data) => json.encode(data.toJson());

class CommunityAnswerModel {
  CommunityAnswerModel({
    this.status,
    this.message,
    this.communityAnswer,
  });

  bool? status;
  String? message;
  List<CommunityAnswer>? communityAnswer;

  factory CommunityAnswerModel.fromJson(Map<String, dynamic> json) => CommunityAnswerModel(
    status: json["status"],
    message: json["message"],
    communityAnswer: List<CommunityAnswer>.from(json["data"].map((x) => CommunityAnswer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(communityAnswer!.map((x) => x.toJson())),
  };
}

class CommunityAnswer {
  CommunityAnswer({
    this.id,
    this.userId,
    this.communityId,
    this.description,
    this.files,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? communityId;
  String? description;
  String? files;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CommunityAnswer.fromJson(Map<String, dynamic> json) => CommunityAnswer(
    id: json["id"],
    userId: json["user_id"],
    communityId: json["community_id"],
    description: json["description"],
    files: json["files"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "community_id": communityId,
    "description": description,
    "files": files,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}


///community Profile miodel

CommunityProfileModel communityProfileModelFromJson(String str) => CommunityProfileModel.fromJson(json.decode(str));

String communityProfileModelToJson(CommunityProfileModel data) => json.encode(data.toJson());

class CommunityProfileModel {
  CommunityProfileModel({
    this.status,
    this.message,
    this.communityProfileData,
  });

  bool? status;
  String? message;
  CommunityProfileData? communityProfileData;

  factory CommunityProfileModel.fromJson(Map<String, dynamic> json) => CommunityProfileModel(
    status: json["status"],
    message: json["message"],
    communityProfileData: CommunityProfileData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": communityProfileData!.toJson(),
  };
}

class CommunityProfileData {
  CommunityProfileData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.dob,
    this.profile,
    this.gender,
    this.userType,
    this.status,
    this.socialName,
    this.socialId,
    this.schoolName,
    this.subDivision,
    this.commDesc,
    this.userToken,
    this.deviceToken,
    this.forgotid,
    this.createdAt,
    this.updatedAt,
    this.totalPost,
    this.totalReplay,
    this.totalLike,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  DateTime? dob;
  String? profile;
  String? gender;
  int? userType;
  int? status;
  dynamic socialName;
  dynamic socialId;
  String? schoolName;
  String? subDivision;
  dynamic commDesc;
  String? userToken;
  String? deviceToken;
  dynamic forgotid;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? totalPost;
  int? totalReplay;
  int? totalLike;

  factory CommunityProfileData.fromJson(Map<String, dynamic> json) => CommunityProfileData(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    dob: DateTime.parse(json["dob"]),
    profile: json["profile"],
    gender: json["gender"],
    userType: json["user_type"],
    status: json["status"],
    socialName: json["social_name"],
    socialId: json["social_id"],
    schoolName: json["school_name"],
    subDivision: json["sub_division"],
    commDesc: json["comm_desc"],
    userToken: json["user_token"],
    deviceToken: json["device_token"],
    forgotid: json["forgotid"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    totalPost: json["total_post"],
    totalReplay: json["total_replay"],
    totalLike: json["total_like"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "profile": profile,
    "gender": gender,
    "user_type": userType,
    "status": status,
    "social_name": socialName,
    "social_id": socialId,
    "school_name": schoolName,
    "sub_division": subDivision,
    "comm_desc": commDesc,
    "user_token": userToken,
    "device_token": deviceToken,
    "forgotid": forgotid,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "total_post": totalPost,
    "total_replay": totalReplay,
    "total_like": totalLike,
  };
}
