import 'package:easy_grade/pages/sign_up_page/sign_up_page.dart';
import 'package:easy_grade/widgets/app_button.dart';
import 'package:easy_grade/widgets/app_image_assets.dart';
import 'package:flutter/material.dart';

import '../../constant/color_constant.dart';
import '../../generated/l10n.dart';
import '../../widgets/app_text.dart';
import '../sign_in_page/sign_in_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorConstant.appWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.2),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 45,right: 40),
                child: AppImageAsset(
                  image: AppAsset.appLogo,
                   height: 250.0,
                   width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: height * 0.020,
              ),
              child: AppText(
                text: S.of(context).hello,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 10),
               child: AppText(
                text: S.of(context).welcomeMsg,
                fontSize: 14,
                maxLines: 3,
                fontWeight: FontWeight.w900,
                textColor: Colors.grey,
                textAlign: TextAlign.center,
            ),
             ),
            AppButton(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (c) => const SignInPage()),
                        (route) => false);
              },
              padding: EdgeInsets.only(left: 45, right: 45, top: height * 0.060, bottom: height * 0.040),
              buttonText: S.of(context).login,
            ),
            AppWithoutBgButton(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (c) => const SignUpPage()),
                        (route) => false);
              },
              padding: const EdgeInsets.symmetric(horizontal: 45),
              buttonText: S.of(context).signUp,
            )
          ],
        ),
      ),
    );
  }
}
