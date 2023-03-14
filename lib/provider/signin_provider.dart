import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:easy_grade/services/rest_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../constant/color_constant.dart';
import '../generated/l10n.dart';
import '../pages/dashboard_page/dashboard_page.dart';
import '../shared_preference/shared_preference.dart';
import '../utills/app_logs.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_loader.dart';
import '../widgets/app_text.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController forgotPassController = TextEditingController();
  final forgotFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInUser(context) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await firebaseMessaging.getToken();
    isLoading = true;
    notifyListeners();
    try {
      Map<String, String> body = {
        'email': emailController.text,
        'password': passwordController.text,
        'device_token': fcmToken!
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.signIn, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          await setPrefStringValue(userKey,jsonEncode(validateUserMap['data']));
          await getStoreUserInfo();
            showDialog(
                context: context,
                builder: (_) =>  CongratulationDialog(
                  titleMsg: S.of(context).loginSuccessfully,
                  subTitleMsg: S.of(context).loginRedirected,
                      icon: const Icon(
                        Icons.check,
                        color: ColorConstant.appWhite,
                        size: 40,
                      ),
                      alertWidget: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20),
                          //SpinKitFadingCube
                          child: AppLoader()),
                    ));
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashBoardPage(selectedIndex: 0)));
                 emailController.clear();
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

  Future<void> forgotPassword(context) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, String> body = {
        'email': forgotPassController.text,
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.forgot, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          showDialog(
              context: context,
              builder: (_) => AppDialog(
                titleMsg: S.of(context).success,
                alertWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: AppText(
                    text: validateUserMap['message'],
                    maxLines: 10,
                  ),
                ),
              ));
          forgotPassController.clear();
        }else{
          errorDialog(context, validateUserMap['message']);
          forgotPassController.clear();
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signWithGoogle(context) async {
    try {
      await googleSignIn.signOut();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
        String? fcmToken = await firebaseMessaging.getToken();
        logs("------>fcmToken $fcmToken");
        isLoading = true;
        notifyListeners();
        try {
          Map<String, String> body = {
            'name': googleSignInAccount.displayName!,
            'email': googleSignInAccount.email  ,
            'phone': '',
            'social_name': 'google',
            'social_id': googleSignInAccount.id,
            'device_token': fcmToken!,
          };

          logs('body --> $body');
          String? validateUser = await RestServices.postRestCall(context,
              endpoint: RestConstants.signLogin, body: body);
          if (validateUser != null && validateUser.isNotEmpty) {
            Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
            logs("---->validateUserMap $validateUserMap");
            if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
              await removePrefValue(userKey);
              await setPrefStringValue(userKey,jsonEncode(validateUserMap['data']));
              await getStoreUserInfo();
              showDialog(
                  context: context,
                  builder: (_) =>  CongratulationDialog(
                    titleMsg: S.of(context).loginSuccessfully,
                    subTitleMsg: S.of(context).loginRedirected,
                    icon: const Icon(
                      Icons.check,
                      color: ColorConstant.appWhite,
                      size: 40,
                    ),
                    alertWidget: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20),
                        //SpinKitFadingCube
                        child: AppLoader()),
                  ));
              Future.delayed(const Duration(seconds: 3), () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashBoardPage(selectedIndex: 0,)));
              });
            } else {
              errorDialog(context, validateUserMap['message']);
            }
          }
        } on SocketException catch (e) {
          logs('Socket exception -------> ${e.message}');
        }
      }
    } catch (e) {
      logs('Catch error in signInWithGoogle --> $e');
      return;
    }
    isLoading = false;
    notifyListeners();
  }


 signInWithFacebook(context) async {
     await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login();
      if(result.status == LoginStatus.success){
        final userData = await FacebookAuth.instance.getUserData();
          //await getId();
        FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
        String? fcmToken = await firebaseMessaging.getToken();
          isLoading = true;
          notifyListeners();
          try {
            Map<String, String> body = {
              'name':userData['name'],
              'email':userData['email'],
              'phone': '',
              'social_name': 'facebook',
              'social_id': userData['id'],
              'device_token': fcmToken!,
            };

            logs('body --> $body');
            String? validateUser = await RestServices.postRestCall(context,
                endpoint: RestConstants.signLogin, body: body);
            if (validateUser != null && validateUser.isNotEmpty) {
              Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
              logs("---->validateUser $validateUser");
              logs("---->validateUserMap $validateUserMap");
              if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
                await removePrefValue(userKey);
                await setPrefStringValue(userKey,jsonEncode(validateUserMap['data']));
                await getStoreUserInfo();
                showDialog(
                    context: context,
                    builder: (_) =>  CongratulationDialog(
                      titleMsg: S.of(context).loginSuccessfully,
                      subTitleMsg: S.of(context).loginRedirected,
                      icon: const Icon(
                        Icons.check,
                        color: ColorConstant.appWhite,
                        size: 40,
                      ),
                      alertWidget: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20),
                          //SpinKitFadingCube
                          child: AppLoader()),
                    ));
                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashBoardPage(selectedIndex: 0)));
                });
              } else {
                errorDialog(context, validateUserMap['message']);
              }
            }
          } on SocketException catch (e) {
            logs('Socket exception -------> ${e.message}');
          }
      }
       isLoading = false;
       notifyListeners();
       return null;
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  signInWithApple(context) async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      print("-->appleCredential identityToken :--  ${ appleCredential.identityToken}");
      print("-->appleCredential:--  $appleCredential");

      final oAuthProvider = OAuthProvider('apple.com');
      final AuthCredential credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      UserCredential? myUser = await signFirebase(credential);

      print("myUser:--  ${myUser}");

      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? fcmToken = await firebaseMessaging.getToken();
      if(myUser != null) {
        Map<String, String> body = {
          'name': myUser.user!.displayName!,
          'email': myUser.user!.email!,
          'phone': '',
          'social_name': 'apple',
          'social_id': myUser.credential!.token.toString(),
          'device_token': fcmToken!,
        };

        logs('body --> $body');
        String? validateUser = await RestServices.postRestCall(context,
            endpoint: RestConstants.signLogin, body: body);
        if (validateUser != null && validateUser.isNotEmpty) {
          Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
          logs("---->validateUser $validateUserMap");
          if (validateUserMap.isNotEmpty &&
              validateUserMap['status'] == true) {
            await removePrefValue(userKey);
            await setPrefStringValue(
                userKey, jsonEncode(validateUserMap['data']));
            await getStoreUserInfo();
            showDialog(
                context: context,
                builder: (_) =>
                    CongratulationDialog(
                      titleMsg: S
                          .of(context)
                          .loginSuccessfully,
                      subTitleMsg: S
                          .of(context)
                          .loginRedirected,
                      icon: const Icon(
                        Icons.check,
                        color: ColorConstant.appWhite,
                        size: 40,
                      ),
                      alertWidget: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20),
                          //SpinKitFadingCube
                          child: AppLoader()),
                    ));
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const DashBoardPage(selectedIndex: 0)));
            });
          } else {
            errorDialog(context, validateUserMap['message']);
          }
        }
      }
    } catch (e) {
      print('Catch error in sign In With Apple --> $e');
    }
  }


  Future<UserCredential?> signFirebase(credential) async {
    try {
      UserCredential myUser = await FirebaseAuth.instance.signInWithCredential(credential);
      return myUser;
    } catch (e) {
      print("------->signFirebase ${e}");
      return null;
    }
  }

}

