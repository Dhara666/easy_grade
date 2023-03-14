import 'package:easy_grade/constant/color_constant.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String? buttonText;
  final GestureTapCallback? onTap;
  final Color? gradient1;
  final Color? gradient2;


  final EdgeInsets? padding;
  final double? borderRadius;
  final double? fontSize;
  final  FontWeight? fontWeight;
  final double? height;
  final double? width;
  const AppButton(
      {Key? key,
      this.buttonText,
      this.gradient1,
      this.gradient2,
      this.onTap,
        this.padding,
        this.borderRadius = 8.0,this.fontSize = 17.0,
        this.fontWeight = FontWeight.w400,
        this.height, this.width
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
          child: Container(
            height: height ?? 48.0,
            width: width ?? double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius!),
              gradient: LinearGradient(colors: [
                gradient1 ?? const Color(0xFF0500a0),
                gradient2 ?? const Color(0xFF3c00f3),
              ])
            ),
            child: Center(
                child: Text(
              buttonText!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  letterSpacing: 0.9),
            )),
          ),
        ));
  }
}


class AppWithoutBgButton extends StatelessWidget {
  final String? buttonText;
  final GestureTapCallback? onTap;
  final EdgeInsets? padding;
  final  Color? borderColor;
  final  Color? buttonColor;
  final  Color? textColor;
  final  double? borderRadius;
  final  double? fontSize;
  final  FontWeight? fontWeight;

  const AppWithoutBgButton(
      {Key? key,
        this.buttonText,
        this.onTap,
        this.padding,
        this.borderColor,
        this.buttonColor,
        this.textColor,
        this.borderRadius =8.0,
        this.fontSize =17.0,
        this.fontWeight =FontWeight.w400,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
          child: Container(
            height: 48.0,
            width: double.infinity,
            decoration: BoxDecoration(
               color: buttonColor ?? Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius!),
                border: Border.all(color: borderColor ?? const Color(0xFF0500a0),width: 3),
            ),
            child: Center(
                child: Text(
                  buttonText!,
                  style:  TextStyle(
                      color: textColor ??  ColorConstant.appThemeColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      fontFamily: "Sofia",
                      letterSpacing: 0.9),
                )),
          ),
        ));
  }
}