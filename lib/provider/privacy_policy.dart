import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constant/color_constant.dart';
import '../widgets/app_text.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.appWhite,
          iconTheme: const IconThemeData(
            color: ColorConstant.appBlack,
          ),
          elevation: 0.0,
          titleSpacing: 0.0,
          title: const AppText(
              text: "Privacy Policy",
              fontSize: 18,
              textColor: ColorConstant.appBlack),
        ),
        backgroundColor: ColorConstant.appWhite,
        body:const WebView(
          initialUrl: 'https://easygrade.online/privacy_policy',
        )
    );
  }
}
