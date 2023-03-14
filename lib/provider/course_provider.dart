
import 'dart:convert';
import 'dart:io';

import 'package:easy_grade/model/course_video_model.dart';
import 'package:easy_grade/pages/my_course/my_course.dart';
import 'package:easy_grade/widgets/app_dialog.dart';
import 'package:easy_grade/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../constant/color_constant.dart';
import '../generated/l10n.dart';
import '../model/course_book_model.dart';
import '../model/course_model.dart';
import '../services/rest_service.dart';
import '../utills/app_logs.dart';
import '../utills/app_validation.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text.dart';


class CourseProvider extends ChangeNotifier {
  bool isLoading = false;
  List<CourseDetail> myCourseDetail = [];
  List<CourseDetail> searchCourseDetail = [];
  List<CourseBook> myCoursebookDetail = [];
  List<CourseVideo> myCourseVideoDetail = [];
  List<Video> myFilterVideoDetail = [];
  TextEditingController searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  onSearchTextChanged(String text) async {
    searchCourseDetail.clear();
    if (text.isEmpty) {
      notifyListeners();
      return;
    }
    for (var documentModel in myCourseDetail) {
      if (documentModel.topicName!.toLowerCase().contains(text.toLowerCase())) {
        searchCourseDetail.add(documentModel);
      }
    }
    notifyListeners();
  }

  Future<void> getCourse(context) async {
    myCourseDetail.clear();
     isLoading = true;
     // notifyListeners();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.getCourse, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          CourseModel courseModel = courseModelFromJson(validateUser);
          if (courseModel.courseDetail != null && courseModel.courseDetail!.isNotEmpty) {
            myCourseDetail = courseModel.courseDetail!;
            notifyListeners();
          }
         } else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!" ) {
           logOutDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
     isLoading = false;
     isLoading = false;
     notifyListeners();
  }

  Future<void> getPdfCourse(context,String tokenId) async {
    myCoursebookDetail.clear();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'topic_id': tokenId
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.getPDFCourse, body: body);
       if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          CourseBookModel courseBookModel = courseBookModelFromJson(validateUser);
          if (courseBookModel.data != null && courseBookModel.data!.isNotEmpty) {
            myCoursebookDetail = courseBookModel.data!;
            notifyListeners();
          }
        } else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!" ) {
          logOutDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
      // e.message.showToast(isError: true);
    }
  }

  Future<void> addCourse(context,String tokenId) async {
    myCoursebookDetail.clear();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'qr_id': tokenId
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.addUserCourse, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          showDialog(
              context: context,
              builder: (_) => CongratulationDialog(
                titleMsg: S.of(context).enrollCourseSuccessful,
                subTitleMsg: S.of(context).enrollCourseMsg,
                icon: const Icon(
                  Icons.check_box_rounded,
                  color: ColorConstant.appWhite,
                  size: 40,
                ),
                alertWidget: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    //SpinKitFadingCube
                    child: Column(
                      children: [
                        AppButton(onTap: (){
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyCourse()));
                        },buttonText:S.of(context).viewCourse
                            ,borderRadius: 30,fontSize: 14, fontWeight: FontWeight.w900),
                        AppWithoutBgButton(onTap: (){
                          Navigator.pop(context);
                        },
                          textColor: ColorConstant.appBlue,
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          buttonColor: ColorConstant.appBlue.withOpacity(0.2),
                          buttonText:S.of(context).viewEReceipt,)
                      ],
                    )),
              ));
        }
        else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
        else {
          errorDialog(context, validateUserMap['message']);
        }

      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
  }

  Future<void> getVideo(context,String tokenId) async {
    myCourseVideoDetail.clear();
    myFilterVideoDetail.clear();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'topic_id': tokenId
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.getVideoCourse, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          CourseVideoModel courseVideoModel = courseVideoModelFromJson(validateUser);
          if (courseVideoModel.data != null && courseVideoModel.data!.isNotEmpty) {
            myCourseVideoDetail = courseVideoModel.data!;
            for (var element in myCourseVideoDetail) {
              element.videos?.forEach((videosElement) {
                myFilterVideoDetail.add(Video(
                    mySectionName: element.sectionName,
                    id: videosElement.id,
                    videoThumbnail: videosElement.videoThumbnail,
                    videoFile: videosElement.videoFile,
                    videoLength: videosElement.videoLength,
                    sectionId: videosElement.sectionId,
                    createdAt: videosElement.createdAt,
                    title: videosElement.title,
                    topicId: videosElement.topicId,
                    updatedAt: videosElement.updatedAt,
                    iswatch:  videosElement.iswatch
                ));
              });
            }
            notifyListeners();
          }
        }
        else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
      // e.message.showToast(isError: true);
    }
  }

  Future<void> videoComplete(context,String videoId, {String? topicId}) async {
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'video_id': videoId
      };

      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.videoComplete, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          if(topicId != null) {
            await getVideo(context, topicId);
          }
        }  else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }

  }

  Future<void> courseComplete(context,String topicId) async {
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'topic_id': topicId
      };
      logs('body --> $body');

      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.courseComplete, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          double courseRating = 1;
          TextEditingController reviewController = TextEditingController();
          await showDialog(
              context: context,
              builder: (_) => CongratulationDialog(
                titleMsg: "${S.of(context).courseCompleted}!",
                subTitleMsg: S.of(context).reviewDec,
                icon: const Icon(
                  Icons.edit,
                  color: ColorConstant.appWhite,
                  size: 40,
                ),
                alertWidget: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20),
                  child: Column(
                    children: [
                      Form(
                        key : formKey,
                        child: AppTextField(
                          validator: (value) =>
                              emptyValidator(value!, S.of(context).validReview),
                          controller: reviewController,
                          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          fillColor: ColorConstant.appBlue.withOpacity(0.06),
                          hint: S.of(context).enterReview,enabledBorder: AppTextField.appOutlineInputBorder(color: ColorConstant.appGrey),focusedBorder: AppTextField.appOutlineInputBorder(),
                          errorBorder: AppTextField.appOutlineInputBorder(color: Colors.red) ,
                        ),
                      ),
                      RatingBar.builder(
                        initialRating: 1,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: ColorConstant.appLightBlue,
                        ),
                        onRatingUpdate: (rating) {
                          courseRating = rating;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppButton(
                          onTap: () async {
                            if(formKey.currentState!.validate()){
                              await appReviewComplete(context,topicId: topicId,review: reviewController.text,reviewStar: courseRating.toString());
                            }
                          },
                          buttonText: S.of(context).writeReview,
                          borderRadius: 30,
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                      AppWithoutBgButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        textColor: ColorConstant.appBlue,
                        borderColor: Colors.transparent,
                        borderRadius: 30,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        buttonColor: ColorConstant.appBlue
                            .withOpacity(0.2),
                        buttonText: S.of(context).cancel,
                      )
                    ],
                  ),
                ),
              ));
        } else {
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }

  }

  Future<void> appReviewComplete(context,{String? topicId,String? review,String? reviewStar}) async {
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'topic_id': topicId!,
        'review' : review!,
        'review_star' : reviewStar!
      };
      logs('body --> $body');

      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.addReview, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AppDialog(
                titleMsg: S.of(context).success,
                alertWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Column(
                    children: [
                      AppText(
                        text: validateUserMap['message'],
                        maxLines: 10,
                      ),
                      const SizedBox(height: 15,),
                      SizedBox(
                        width: 150,
                        child: AppButton(
                          buttonText:S.of(context).ok,
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ));
        } else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
        else {
          errorDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('SSocket exception -------> ${e.message}');
    }

  }

  Future<void> startCourseAgain(context,String topicId) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'topic_id': topicId
      };
      logs('body --> $body');

      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.startCourseAgain, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AppDialog(
                titleMsg: S.of(context).success,
                alertWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Column(
                    children: [
                      AppText(
                        text: validateUserMap['message'],
                        maxLines: 10,
                      ),
                      const SizedBox(height: 15,),
                      SizedBox(
                        width: 150,
                        child: AppButton(
                          buttonText:S.of(context).ok,
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                            getCourse(context);

                          },
                        ),
                      )
                    ],
                  ),
                ),
              ));
        } else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteAccount(context) async {
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.deleteAccount, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          logOutDialog(context, validateUserMap['message'],diaLogTitle: S.of(context).success);
        } else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!" ) {
          logOutDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
  }


}

