import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../utills/app_logs.dart';

class RestConstants {
  static String baseUrl = "https://easygrade.online/api";
  static String signUp = "signup";
  static String signIn = "signin";
  static String signLogin = "socialsignin";
  static String forgot = "forgot";
  static String updateProfile = "update_profile";
  static String updatePassword = "update_password";
  static String getNotification = "get_notification";
  static String getCourse = "get_course";
  static String getPDFCourse = "get_course_book";
  static String getVideoCourse = "get_course_video";
  static String addUserCourse = "add_user_course";
  static String videoComplete = "video_completed";
  static String courseComplete = "course_completed";
  static String addReview = "add_review";
  static String getCalendar = "get_calendar";
  static String getUserCommunity = "get_community";
  static String getUserAnswerCommunity = "get_community_ans";
  static String addUserCommunity = "add_community";
  static String updateUserCommunity = "update_community";
  static String deleteUserCommunity = "delete_community";
  static String getAllCommunity = "community";
  static String getAnswerCommunity = "community_data";
  static String addAnswerCommunity = "add_community_ans";
  static String deleteAnswerCommunity = "delete_community_ans";
  static String updateAnswerCommunity = "update_community_ans";
  static String like = "community_like";
  static String getCourseCommunity = "getcourse_community";
  static String addForm = "get_help";
  static String helpCenterList = "help_center";
  static String helpNumber = "helpnumber";
  static String communityProfile = "community_profile";
  static String communityDescription  = "edit_comm_desc";
  static String communityView  = "community_view";
  static String startCourseAgain = "start_course_again";
  static String deleteAccount = "delete_account";
}

class RestServices {
   static Map<String, String> headers = {'Accept': 'application/json'};

  static void showRequestAndResponseLogs(
      http.Response? response, Map<String, Object> requestData) {
    log(':::::::::: Network logs :::::::::: ');
    log('request url ------> ${response?.request?.url}');
    log('status code ------> ${response?.statusCode}');
    log('response body ------> ${response?.body}');
    log('::::::::::::::::::::::::::::::::::');
  }


  static postRestCall(BuildContext context, {required String? endpoint, required body, String? addOns, bool isImage = false, String? filePath, String? fileParam}) async {
    String? responseData;
    bool connected = await isConnectNetworkWithMessage(context);
    if (!connected) {
      return responseData;
    }
    try {
      String requestUrl = addOns != null
          ? '${RestConstants.baseUrl}/$endpoint/$addOns'
          : '${RestConstants.baseUrl}/$endpoint';
      Uri? requestedUri = Uri.tryParse(requestUrl);

      var request = http.MultipartRequest('POST', requestedUri!);
      request.fields.addAll(body);

      if(isImage == true && filePath != null){
       request.files.add(await http.MultipartFile.fromPath(
           fileParam ?? 'profile', filePath));
      }

      StreamedResponse responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      showRequestAndResponseLogs(response, headers);

      switch (response.statusCode) {
        case 200:
        case 201:
          responseData = response.body;
          break;
        case 500:
        case 400:
        case 404:
          log('${response.statusCode}');
          break;
        case 401:
          log('401 : ${response.body}');
          break;
        default:
          log('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      logs('PlatformException in postRestCall --> ${e.message}');
    }
    return responseData;
  }

}
