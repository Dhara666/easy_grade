import 'dart:convert';
import 'dart:io';
import 'package:easy_grade/services/rest_service.dart';
import 'package:easy_grade/utills/app_logs.dart';
import 'package:easy_grade/widgets/app_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constant/color_constant.dart';
import '../generated/l10n.dart';
import '../pages/dashboard_page/dashboard_page.dart';
import '../shared_preference/shared_preference.dart';

class SignUpProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController subDivisionController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> signUpUser(context) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await firebaseMessaging.getToken();
    logs("-------fcm token: $fcmToken");
    isLoading = true;
    notifyListeners();
    try {
      Map<String, String> body = {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'dob': dobController.text,
        'gender': 'Male',
        'password': passwordController.text,
        'device_token': fcmToken!,
        'school_name':schoolNameController.text,
        'sub_division':subDivisionController.text
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.signUp, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          await setPrefStringValue(userKey,jsonEncode(validateUserMap['data']));
          getStoreUserInfo();
          showDialog(
              context: context,
              builder: (_) => CongratulationDialog(
                    titleMsg: S.of(context).congratulations,
                    subTitleMsg:S.of(context).loginRedirected,
                    icon: const Icon(
                      CupertinoIcons.person_fill,
                      color: ColorConstant.appWhite,
                      size: 40,
                    ),
                    alertWidget: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: SpinKitCircle(
                        color: ColorConstant.appBlue,
                        size: 50,
                      ),
                    ),
                  ));
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const DashBoardPage(selectedIndex: 0)));
            nameController.clear();
            emailController.clear();
            phoneController.clear();
            dobController.clear();
            passwordController.clear();
          });
        } else {
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
