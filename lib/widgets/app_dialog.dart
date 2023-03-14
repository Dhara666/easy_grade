import 'package:easy_grade/constant/color_constant.dart';
import 'package:easy_grade/widgets/app_image_assets.dart';
import 'package:flutter/material.dart';
import 'app_text.dart';

class CongratulationDialog extends StatefulWidget {
  const CongratulationDialog({Key? key,this.icon,this.titleMsg,this.subTitleMsg,this.alertWidget}) : super(key: key);
  final Widget? icon;
  final String? titleMsg;
  final String? subTitleMsg;
  final Widget? alertWidget;

  @override
  CongratulationDialogState createState() => CongratulationDialogState();
}

class CongratulationDialogState extends State<CongratulationDialog> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    // easeInCirc
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.fastLinearToSlowEaseIn);

    controller.addListener(() {});

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(15.0)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                   const AppImageAsset(
                      height: 200,
                      width: 250,
                      image : "asset/image/background.png",
                      fit: BoxFit.cover,
                    ),
                    Container(
                        height: 100,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorConstant.appBlue),
                        child: widget.icon
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        bottom: 15, left: 15, right: 15),
                    child: AppText(
                      text: widget.titleMsg,
                      textColor: ColorConstant.appBlue,
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppText(
                    text:
                    widget.subTitleMsg,
                    //    "Your account is ready to use, you will redirect to home page in a few seconds",
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    textColor: ColorConstant.appGrey,
                  ),
                ),
                widget.alertWidget!
              ],
            ),
          ),
        )
      ),
    );
  }
}



class AppDialog extends StatefulWidget {
  const AppDialog({Key? key,this.titleMsg,this.alertWidget}) : super(key: key);

  final String? titleMsg;
  final Widget? alertWidget;

  @override
  AppDialogState createState() => AppDialogState();
}

class AppDialogState extends State<AppDialog> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInSine);

    controller.addListener(() {});

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
          scale: scaleAnimation,
          child: Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(15.0)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 15, right: 15,top: 10),
                      child: AppText(
                        text: widget.titleMsg,
                        textColor: ColorConstant.appBlue,
                        textAlign: TextAlign.center,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
                  widget.alertWidget!
                ],
              ),
            ),
          )
      ),
    );
  }
}