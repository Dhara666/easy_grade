import 'package:flutter/material.dart';
import '../constant/color_constant.dart';

class AppText extends StatelessWidget {
  final String? text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextDecoration? decoration;
  final TextStyle? textStyle;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double letterSpacing;

  const AppText({
    Key? key,
    this.text,
    this.textAlign,
    this.maxLines,
    this.decoration = TextDecoration.none,
    this.textStyle,
    this.textColor,
    this.fontSize = 14,
    this.fontWeight,
    this.letterSpacing = 0.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Text('$text',
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: textStyle ??
            TextStyle(
               fontFamily: AppAsset.defaultFont,
                color: textColor ?? ColorConstant.appThemeColor,
                fontSize: fontSize,
                letterSpacing: letterSpacing,
                fontWeight: fontWeight ?? FontWeight.w600,
                decoration: decoration));
  }
}
