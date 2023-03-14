import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_grade/pages/intro_page/intro_page.dart';
import 'package:easy_grade/widgets/app_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../generated/l10n.dart';
import '../model/user_model.dart' as user;
import '../pages/splash_page/splash_page.dart';
import '../shared_preference/shared_preference.dart';
import '../widgets/app_button.dart';
import '../widgets/app_dialog.dart';

void logs(String message) {
  if (kDebugMode) {
    print(message);
  }
}

Connectivity connectivity = Connectivity();

Future<bool> isConnectNetworkWithMessage(context,
    {bool showToast = true}) async {
  ConnectivityResult connectivityResult =
  await connectivity.checkConnectivity();
  bool isConnect = getConnectionValue(connectivityResult);
  if (!isConnect && showToast) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>  AppDialog(
          titleMsg: S.of(context).noInternetConnection,
          alertWidget: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: AppText(text: S.of(context).noInternetConnectionMsg,maxLines: 5,textAlign: TextAlign.center)),
              ),
              const SizedBox(height: 20,),
              AppButton(
                  onTap: (){
                    Navigator.pop(context);
                  },buttonText: S.of(context).ok,borderRadius: 30,fontSize: 16, fontWeight: FontWeight.w900),
            ],
          ),
        )
    );
  }
  return isConnect;
}

bool getConnectionValue(ConnectivityResult connectivityResult) {
  bool status = false;
  switch (connectivityResult) {
    case ConnectivityResult.mobile:
    case ConnectivityResult.wifi:
    case ConnectivityResult.ethernet:
      status = true;
      break;
    default:
      break;
  }
  return status;
}

void pickImage(context, VoidCallback onCameraPress, VoidCallback onLibPress) {
  final action = CupertinoActionSheet(
    actions: <Widget>[
      CupertinoActionSheetAction(
        onPressed: onCameraPress,
        child:  Text(
          S.of(context).takeAPhoto,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      CupertinoActionSheetAction(
        onPressed: onLibPress,
        child: Text(
            S.of(context).chooseFromLibrary,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            )),
      ),
    ],
    cancelButton: CupertinoActionSheetAction(
      child: Text(
        S.of(context).cancel,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    ),
  );

  showCupertinoModalPopup(context: context, builder: (context) => action);
}

user.UserInfo? userInfo;

getStoreUserInfo() async {
  var userData = await getPrefStringValue(userKey);
  if (userData != null) {
    userInfo = user.UserInfo.fromJson(jsonDecode(userData!));
    logs("----->userInfo ${userInfo?.email}");
    logs("----->user id ${userInfo?.id}");
    logs("----->user device_token ${userInfo?.userToken}");
  }
}

errorDialog(context,errorMsg){
 return showDialog(
      context: context,
      builder: (_) => AppDialog(
        titleMsg: S.of(context).alert,
        alertWidget: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: AppText(
            text: errorMsg,
            maxLines: 10,
          ),
        ),
      ));
}


logOutDialog(context,errorMsg,{String? diaLogTitle}){
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppDialog(
        titleMsg: diaLogTitle ?? S.of(context).alert,
        alertWidget: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            children: [
              AppText(
                text: errorMsg,
                maxLines: 10,
              ),
              const SizedBox(height: 15,),
              SizedBox(
                width: 150,
                child: AppButton(
                  buttonText:S.of(context).ok,
                  onTap: () async {
                    final tasks = await FlutterDownloader.loadTasks();
                    tasks?.forEach((element) async {
                      await FlutterDownloader.remove(
                        taskId: element.taskId,
                        shouldDeleteContent: true,
                      );
                    });
                    await removePrefValue(userKey);
                    await removePrefValue(downloadList);
                    myVideo.clear();
                    await GoogleSignIn().signOut();
                    await FacebookAuth.instance.logOut();
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) => const IntroPage()),
                            (route) => false);
                  },
                ),
              )
            ],
          ),
        ),
      ));
}
