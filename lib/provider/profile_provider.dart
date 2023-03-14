import 'dart:convert';
import 'dart:io';
import 'package:easy_grade/services/rest_service.dart';
import 'package:easy_grade/utills/app_logs.dart';
import 'package:easy_grade/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../generated/l10n.dart';
import '../model/user_model.dart';
import '../shared_preference/shared_preference.dart';
import '../widgets/app_text.dart';

class ProfileProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController subdivisionController = TextEditingController();
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  String? dropDownValue;
  bool isLoading = false;
  String? deviceId;
  File? profileImage;
  String? networkImg;

  Future<String?> getUserInfo() async {
    var userData = await getPrefStringValue(userKey);
    if (userData != null) {
      userInfo = UserInfo.fromJson(jsonDecode(userData!));
      nameController.text =  userInfo!.name!;
      emailController.text =  userInfo!.email!;
      phoneController.text =  userInfo!.phone ?? '';
      dobController.text =  userInfo!.dob!;
      dropDownValue = userInfo!.gender!;
      schoolNameController.text = userInfo!.schoolName ?? '';
      subdivisionController.text = userInfo!.subDivision ?? '';
      networkImg = userInfo!.profile!;
      notifyListeners();
     }else {
    }
    return null;
  }

  selectImage(context) {
    pickImage(context, () async {
      Navigator.of(context, rootNavigator: true).pop();
      var image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        profileImage = File(image.path);
        notifyListeners();
      }
    }, () async {
      Navigator.of(context, rootNavigator: true).pop();
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        profileImage = File(image.path);
        notifyListeners();
      }
    });
  }

  Future<void> updateUser(context) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'name': nameController.text,
    //    'email': userInfo!.email!,
        'email': emailController.text,
        'phone':  phoneController.text,
        'dob': dobController.text,
        'gender': dropDownValue.toString(),
        'school_name': schoolNameController.text,
        'sub_division': subdivisionController.text
      };

      logs('body --> $body');

      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.updateProfile, body: body,isImage: true,filePath: profileImage?.path);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          await removePrefValue(userKey);
          await setPrefStringValue(userKey,jsonEncode(validateUserMap['data']));
          await getStoreUserInfo();
          showDialog(
              context: context,
              builder: (_) => AppDialog(
                titleMsg: S.of(context).success,
                alertWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: AppText(
                    text: validateUserMap['message'],
                    maxLines: 10,
                  ),
                ),
              ));
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
    isLoading = false;
    notifyListeners();
  }


  Future<void> changePasswordUser(context) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'oldpass': oldPassController.text,
        'newpass': newPassController.text,
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.updatePassword, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          FocusScope.of(context).requestFocus(FocusNode());
          showDialog(
              context: context,
              builder: (_) => AppDialog(
                titleMsg: S.of(context).success,
                alertWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0,left: 10,right: 10),
                  child: AppText(
                    text: validateUserMap['message'],
                    maxLines: 10,
                  ),
                ),
              ));
          oldPassController.clear();
          newPassController.clear();
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
    isLoading = false;
    notifyListeners();
  }
}
