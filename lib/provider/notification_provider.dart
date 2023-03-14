import 'dart:convert';
import 'dart:io';
import 'package:easy_grade/model/academic_calender_model.dart';
import 'package:easy_grade/model/notification_model.dart';
import 'package:flutter/cupertino.dart';
import '../services/rest_service.dart';
import '../utills/app_logs.dart';

class NotificationProvider extends ChangeNotifier {
  bool isLoading = true;
  List<Datum> notification =[];
  List<CalenderDetail> eventCalender =[];

  Future<void> getNotification(context) async {
    if(userInfo!.userToken!.isEmpty){
      await getStoreUserInfo();
      notifyListeners();
    }
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.getNotification, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        logs("---->validateUserMap $validateUserMap");
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          NotificationModel notificationModel = notificationModelFromJson(validateUser);
          if (notificationModel.data != null && notificationModel.data!.isNotEmpty) {
            notification = notificationModel.data!;
            notifyListeners();
          }
        }   else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
     isLoading = false;
    notifyListeners();
  }

  Future<void> getCalender(context) async {
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.getCalendar, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        logs("---->validateUserMap $validateUserMap");
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          AcademicCalenderModel academicCalenderModel = academicCalenderModelFromJson(validateUser);
          if (academicCalenderModel.data != null && academicCalenderModel.data!.isNotEmpty) {
            eventCalender = academicCalenderModel.data!;
            notifyListeners();
          }
        }  else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
  }
}