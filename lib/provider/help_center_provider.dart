import 'dart:convert';
import 'dart:io';

import 'package:easy_grade/services/rest_service.dart';
import 'package:easy_grade/widgets/app_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../model/form_chat_list_model.dart';
import '../utills/app_logs.dart';
import '../widgets/app_button.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_text.dart';

class HelpCenterProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  List<FormChatList> chatListData =[];
  String? helpNumber;
  String? helpEmail;

  Future<void> addForm(context) async {
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'email':emailController.text,
        'phone':phoneController.text,
        'subject':subjectController.text,
        'message':messageController.text,
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.addForm, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AppDialog(
                titleMsg: S.of(context).success,
                alertWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    children: [
                      AppText(
                        text: validateUserMap['message'],
                        maxLines: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                          width: 100,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            emailController.clear();
                            phoneController.clear();
                            subjectController.clear();
                            messageController.clear();
                          },
                          buttonText: S.of(context).ok,
                          borderRadius: 10,
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                    ],
                  ),
                ),
              ));
        }  else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
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


  Future<void> getFormData(context) async {
    chatListData.clear();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.helpCenterList, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          FormChatListModel formChatListModel = formChatListModelFromJson(validateUser);
          if (formChatListModel.formChatList != null && formChatListModel.formChatList!.isNotEmpty) {
            chatListData = formChatListModel.formChatList!;
            notifyListeners();
          }
         }   else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
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

  Future<void> getHelpNumber(context) async {
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.helpNumber, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          helpNumber = validateUserMap['data'][0]['phone'];
          helpEmail = validateUserMap['data'][0]['email'];
          notifyListeners();
        } else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
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
}

