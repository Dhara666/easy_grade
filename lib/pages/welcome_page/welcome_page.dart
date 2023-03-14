import 'package:easy_grade/constant/color_constant.dart';
import 'package:easy_grade/pages/dashboard_page/dashboard_page.dart';
import 'package:easy_grade/pages/intro_page/intro_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:video_player/video_player.dart';
import '../../generated/l10n.dart';
import '../../main.dart';
import '../../services/notification_service.dart';
import '../../utills/app_logs.dart';
import '../../widgets/app_text.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {

  late VideoPlayerController _controller;

   @override
   void initState() {
     super.initState();
     _controller = VideoPlayerController.asset(AppAsset.welcomeVideo)
       ..initialize().then((_) {
          setState(() {});
         _controller.play();
       });
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.appWhite,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                 aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
               )
                : Container(),
          ),
          Positioned(
            bottom: 30,
            child: InkWell(
              onTap: () async {
                await getStoreUserInfo();
                RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
                  if (initialMessage != null) {
                    if(userInfo!= null) {
                      Navigator.of(this.context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (c) => const DashBoardPage(selectedIndex: 2)),
                              (route) => false);
                    }
                    else{
                      Navigator.of(this.context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (c) => const IntroPage()),
                              (route) => false);
                    }
                  }
                  else{
                    if(userInfo!= null) {
                      Navigator.of(this.context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (c) => const DashBoardPage(selectedIndex: 0)),
                              (route) => false);
                    }
                    else{
                      Navigator.of(this.context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (c) => const IntroPage()),
                              (route) => false);
                    }
                  }
              },
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorConstant.appBlack,width: 1.5),
                ),
                child: Center(child: AppText(text :S.of(context).continueWithApp,textColor: ColorConstant.appBlack,maxLines: 2,fontWeight: FontWeight.w500,textAlign: TextAlign.center)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
