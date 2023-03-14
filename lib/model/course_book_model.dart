// To parse this JSON data, do
//
//     final courseBookModel = courseBookModelFromJson(jsonString);

import 'dart:convert';

CourseBookModel courseBookModelFromJson(String str) => CourseBookModel.fromJson(json.decode(str));

String courseBookModelToJson(CourseBookModel data) => json.encode(data.toJson());

class CourseBookModel {
  CourseBookModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<CourseBook>? data;

  factory CourseBookModel.fromJson(Map<String, dynamic> json) => CourseBookModel(
    status: json["status"],
    message: json["message"],
    data: List<CourseBook>.from(json["data"].map((x) => CourseBook.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CourseBook {
  CourseBook({
    this.sectionName,
    this.books,
  });

  dynamic sectionName;
  List<Book>? books;

  factory CourseBook.fromJson(Map<String, dynamic> json) => CourseBook(
    sectionName: json["section_name"],
    books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "section_name": sectionName,
    "books": List<dynamic>.from(books!.map((x) => x.toJson())),
  };
}

class Book {
  Book({
    this.id,
    this.topicId,
    this.sectionId,
    this.bookName,
    this.pdfFile,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? topicId;
  dynamic sectionId;
  String? bookName;
  String? pdfFile;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    topicId: json["topic_id"],
    sectionId: json["section_id"],
    bookName: json["book_name"],
    pdfFile: json["pdf_file"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "topic_id": topicId,
    "section_id": sectionId,
    "book_name": bookName,
    "pdf_file": pdfFile,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
