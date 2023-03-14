import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/color_constant.dart';
import '../../generated/l10n.dart';
import '../../model/course_video_model.dart';
import '../../shared_preference/shared_preference.dart';
import '../welcome_page/welcome_page.dart';

List<Video> myVideo = [];

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    getLanguage();
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => const WelcomePage()),
              (route) => false);
    });
    super.initState();
  }

  getLanguage() async {
    var value = await getPrefStringValue("local");
    changeLanguage(value);
  }

  void changeLanguage(String localization) {
    switch (localization) {
      case 'English':
        S.load(const Locale.fromSubtags(countryCode: 'US', languageCode: 'en'));
        break;
      case 'French':
        S.load(const Locale.fromSubtags(countryCode: 'CA', languageCode: 'fr'));
        break;
      default:
        S.load(const Locale.fromSubtags(countryCode: 'US', languageCode: 'en'));
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.appBlack,
      body: Center(
        child: SizedBox(
           height: 180,
            width: 180,
            child: CircularProgressIndicator(color: Colors.white,backgroundColor: ColorConstant.appGrey.withOpacity(0.2),strokeWidth: 6)) ,
      ),
    );
  }
}
